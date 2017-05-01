class Donator < User

  has_many :donations

  scope :open, -> { where(id: Donation.open.select(:donator_id)) }

  validates :name, presence: true

  mount_uploader :avatar, AvatarUploader

  def donator?
    true
  end

  def qualify(donation, qualification)
    donation.update(donator_qualification: qualification)
    return unless donation.volunteer.present?
    donation.volunteer.update(qualifications_count: qualifications_count + 1,
                             qualifications_total: qualifications_total + qualification)
  end

  def self.anonymous_donator
    find_by_email('anon@anon.com')
  end
end
