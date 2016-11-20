class DeleteTokenWorker
  include Sidekiq::Worker

  def perform(params)
    user = User.find(params[:user_id])
    DeviceTokenManager.new(user: user, device_token: params[:device_token]).delete_token
  end
end
