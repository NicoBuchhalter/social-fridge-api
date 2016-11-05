class PushNotifications
  class << self
    def add_token(user, device_token, device_type)
      device_token = device_token.to_s.gsub(/\s+/, '')
      return true if user.device_tokens.key?(device_token)
      endpoint = sns.create_platform_endpoint(
        platform_application_arn: app_arn(device_type),
        token: device_token
      )
      user.device_tokens[device_token] = { 'device_type' => device_type,
                                           'endpoint_arn' => endpoint[:endpoint_arn] }
      user.save
    end

    def delete_token(user, device_token)
      device_token = device_token.to_s.gsub(/\s+/, '')
      return true unless user.device_tokens.key?(device_token)
      sns.delete_endpoint(endpoint_arn: user.device_tokens[device_token]['endpoint_arn'])
      user.device_tokens.delete(device_token)
      user.save
    end

    def simple_notification(user, i18n_key, i18n_args, data)
      send_notifications_to_user(user, i18n_key, i18n_args, data)
    end

    def device_type_valid?(device_type)
      %w(ios android).include? device_type
    end

    private

    def send_notifications_to_user(user, i18n_key, i18n_args, data)
      return if !user.device_tokens.present? || user.device_tokens.values.empty?
      send_notifications_to_devices(user, i18n_key, i18n_args, data)
    end

    def send_notifications_to_devices(user, i18n_key, i18n_args, data)
      user.device_tokens.each do |device_token, token|
        message = prepare_message(token['device_type'], i18n_key, i18n_args, data).to_json
        begin
          sns.publish(target_arn: token['endpoint_arn'], message: message,
                      message_structure: 'json')
        rescue
          user.device_tokens.delete(device_token)
        end
      end
      user.save if user.device_tokens_changed?
    end

    def prepare_message(device_type, i18n_key, i18n_args, data)
      { default: 'Push' }.merge(
        app_arn_for_device[device_type.to_sym][:json_builder]
        .build_json(i18n_key, i18n_args, data)
      )
    end

    def sns
      @sns_client ||= AWS::SNS::Client.new
    end

    def app_arn(device_type)
      app_arn_for_device[device_type.to_sym][:arn]
    end

    def app_arn_for_device
      { ios: { arn: Rails.application.secrets.sns_app_arn['ios']['arn'],
               json_builder: IosPushJsonBuilder },
        android: {
          arn: Rails.application.secrets.sns_app_arn['android'],
          json_builder: AndroidPushJsonBuilder
        } }
    end
  end
end
