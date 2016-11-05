class EndedDonationsUpdater
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    update_unknown
  end

  private

  def update_unknown
    donations = Donation.where(status: [Donation.statuses[:open], Donation.statuses[:active]])
                        .where('pickup_time_to < ?', DateTime.current)
    donations.update_all(status: Donation.statuses[:unknown])
  end
end
