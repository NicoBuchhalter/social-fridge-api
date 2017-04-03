class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :set_default_values

  def generate_access_token
    payload = { user_id: id }
    TokenManager::AuthToken.encode(payload)
  end

  def donator?
    false
  end

  def fridge?
    false
  end

  def volunteer?
    false
  end

  def qualify(_donation, _qualification)
    raise NoMethodError
  end

  private

  def set_default_values
    self.qualifications_count ||= 0
    self.qualifications_total ||= 0
  end

  def password_required?
    super && !fb_id.present?
  end
end
