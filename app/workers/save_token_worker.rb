class SaveTokenWorker
  include Sidekiq::Worker

  def perform(params)
    user = User.find_by_id(params['user_id'])
    return unless ready?(user)
    return unless device_info?(params)
    DeviceTokenManager.new(
      user: user, device_token: params['device_token'], device_type: params['device_type']
    ).add_token
  end

  private

  def ready?(user)
    return false unless user.present?
    return user.update(device_tokens: {}) if user.device_tokens.nil?
    true
  end

  def device_info?(params)
    params['device_token'].present? && params['device_type'].present?
  end
end
