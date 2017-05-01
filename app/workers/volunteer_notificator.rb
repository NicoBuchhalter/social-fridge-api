class VolunteerNotificator
  include Sidekiq::Worker

  VOLUNTEER_RADIUS = 1.5

  def perform(donation_id)
    donation = Donation.find_by_id(donation_id)
    return unless donation.present?
    volunteers = Volunteer.where.not(lat: nil, lng: nil)
                          .within(VOLUNTEER_RADIUS, origin: [donation.lat, donation.lng])
    volunteers.each do |volunteer|
      NotificateUser.call(user: volunteer, n_type: :donation_nearby, donation: donation,
                          message: donation_nearby_message, date: Time.zone.now,
                          user_from: donation.donator)
    end
  end

  private

  def donation_nearby_message
    I18n.t('push_notification.donation_nearby')
  end
end
