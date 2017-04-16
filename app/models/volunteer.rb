class Volunteer < User
  has_many :donations

  mount_uploader :avatar, AvatarUploader

  def volunteer?
    true
  end

  def qualify(donation, qualification)
    donation.reload.update(volunteer_qualification: qualification)
    return unless donation.donator.present?
    donation.donator.update(qualifications_count: qualifications_count + 1,
                            qualifications_total: qualifications_total + qualification)
  end
end
