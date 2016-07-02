class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_access_token
    payload = { user_id: id }
    TokenManager::AuthToken.encode(payload)
  end
end
