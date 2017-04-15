class DonationAnonymisor
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform
    Donation.where('picked_up_at < ?', 1.day.ago).update_all donator_id: Donator.anonymous_donator.id
  end
end
