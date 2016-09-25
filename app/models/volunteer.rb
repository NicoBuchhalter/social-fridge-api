class Volunteer < User
  has_many :donations

  # mount_uploader :avatar, AvatarUploader

  def volunteer?
    true
  end
end
