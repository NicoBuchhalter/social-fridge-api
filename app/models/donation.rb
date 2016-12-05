class Donation < ActiveRecord::Base
  # Unknown status is when we dont know if the food was delivered or not.
  enum status: [:open, :active, :ongoing, :finished, :cancelled, :unknown]

  belongs_to :donator
  belongs_to :volunteer
  belongs_to :fridge
  acts_as_mappable through: :donator

  validates :donator, :pickup_time_from, :pickup_time_to, presence: true

  after_initialize :default_attributes

  scope :available, -> { open.where('pickup_time_from < :now AND pickup_time_to > :now', now: Time.zone.now) }

  def activation_message
    I18n.t('push_notification.donation_activated', description: description, volunteer: volunteer.name)
  end

  def deactivation_message
     I18n.t('push_notification.donation_deactivated', description: description, volunteer: volunteer.name)
  end

  def activate(activation_params, volunteer)
    update(activation_params.merge(volunteer: volunteer, status: :active, activated_at: Time.zone.now))
    NotificateUser.call(user: donator, n_type: :donation_activated, user_from: volunteer,
                        message: activation_message, date: Time.zone.now)
    self
  end

  def deactivate(volunteer)
    NotificateUser.call(user: donator, n_type: :donation_deactivated, user_from: volunteer,
                        message: deactivation_message, date: Time.zone.now)
    update(volunteer: nil, status: :open, activated_at: nil)
  end

  private

  def default_attributes
    self.status ||= :open
  end
end
