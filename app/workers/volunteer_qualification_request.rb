class VolunteerQualificationRequest
  include Sidekiq::Worker

  def perform(donation_id)
    donation = Donation.find(donation_id)
    return unless donation.present?
    NotificateUser.call(user: donation.volunteer, n_type: :qualification_request, donation: donation,
                        message: qualification_request_message, date: Time.zone.now,
                        user_from: donation.donator)
  end

  private

  def qualification_request_message
    I18n.t('push_notification.qualification_request')
  end
end
