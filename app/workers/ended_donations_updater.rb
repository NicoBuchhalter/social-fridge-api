class EndedDonationsUpdater
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    update_unknown
    update_active
  end

  private

  def update_unknown
    donations = Donation.where(status: [Donation.statuses[:open], Donation.statuses[:active]])
                        .where('pickup_time_to < ?', Time.zone.now)
    donations.update_all(status: Donation.statuses[:unknown])
    donations.each do |donation|
      NotificateUser.call(user: donation.donator, n_type: :donation_expired, donation: donation,
                          message: expiration_message(donation), date: Time.zone.now)
    end
  end

  def update_active
    donations = Donation.where(status: Donation.statuses[:active])
                        .where('activated_at < ?', Time.zone.now - 2.minutes)
    donations.each do |donation|
      NotificateUser.call(user: donation.donator, n_type: :activation_time_passed, donation: donation,
                          message: activation_time_passed_massage(donation), date: Time.zone.now,
                          user_from: donation.volunteer)
    end
    donations.update_all(status: Donation.statuses[:unknown])
  end

  def expiration_message(donation)
    I18n.t('push_notification.donation_expired', description: donation.description)
  end

  def activation_time_passed_massage(donation)
    I18n.t('push_notification.activation_time_passed', description: donation.description)
  end
end
