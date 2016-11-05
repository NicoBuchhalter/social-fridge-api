class PushNotification
  attr_reader :user, :loc_key, :loc_args, :data

  def initialize(options = {})
    @user = options[:user]
    @loc_key = options[:loc_key]
    @loc_args = options[:loc_args]
    @data = options[:data]
  end

  def simple_notification
    return unless can_send?
    user.device_tokens.each do |device_token, token|
      message = prepare_predefined_message(token['device_type'])
      publish_message(token['endpoint_arn'], device_token, message)
    end
  end

  private

  def can_send?
    user.device_tokens.present? && !user.device_tokens.values.empty?
  end

  def prepare_predefined_message(device_type)
    { default: 'Push' }.merge(
      PushJsonBuilder.send(device_type.to_sym, loc_key, loc_args, data)
    ).to_json
  end

  def push_service
    @sns_client ||= Aws::SNS::Client.new
  end

  def publish_message(target_arn, device_token, message)
    push_service.publish(
      target_arn: target_arn,
      message: message,
      message_structure: 'json'
    )
  rescue
    DeviceTokenManager.new(user: user, device_token: device_token).delete_token
  end
end
