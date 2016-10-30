class Donator < User
  include Locatable

  has_many :donations

  scope :open, -> { where(id: Donation.open.select(:donator_id)) }

  validates :name, presence: true

  mount_uploader :avatar, AvatarUploader

  def donator?
    true
  end
end
