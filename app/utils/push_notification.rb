class PushNotification
  attr_reader :user, :message, :data, :n_type

  def initialize(options = {})
    @user = options[:user]
    @message = options[:message]
    @data = options[:data]
    @n_type = options[:n_type]
  end

  def simple_notification
    return unless can_send?
    user.device_tokens.each do |device_token, token|
      prepared_message = prepare_predefined_message(token['device_type'])
      publish_message(token['endpoint_arn'], device_token, prepared_message)
    end
  end

  private

  def can_send?
    user.device_tokens.present? && !user.device_tokens.values.empty?
  end

  # Only works for Android
  def prepare_predefined_message(device_type)
    { default: 'Push' }.merge(
      PushJsonBuilder.send(device_type.to_sym, message, data, n_type)
    ).to_json
  end

  def push_service
    @sns_client ||= Aws::SNS::Client.new
  end

  def publish_message(target_arn, device_token, prepared_message)
    push_service.publish(
      target_arn: target_arn,
      message: prepared_message,
      message_structure: 'json'
    )
  rescue
    DeviceTokenManager.new(user: user, device_token: device_token).delete_token
  end
end
