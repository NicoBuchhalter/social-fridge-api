class DeleteTokenWorker
  include Sidekiq::Worker

  def perform(params)
    return if params[:user_id].nil?
    user = User.find_by_id(params[:user_id])
    return if user.nil?
    DeviceTokenManager.new(user: user, device_token: params[:device_token]).delete_token
  end
end
