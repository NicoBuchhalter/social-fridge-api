class Donation < ActiveRecord::Base
  # Unknown status is when we dont know if the food was delivered or not.
  enum status: [:open, :active, :finished, :cancelled, :unknown]

  belongs_to :donator
  belongs_to :volunteer
  belongs_to :fridge
  acts_as_mappable through: :donator

  validates :donator, :pickup_time_from, :pickup_time_to, presence: true

  after_initialize :default_attributes

  def activation_message
    "El voluntario #{volunteer.name} está yendo a buscar tu donación."
  end

  def activate(activation_params, volunteer)
    update(activation_params.merge(volunteer: volunteer, status: :active))
    NotificateUser.call(user: donator, n_type: :donation_activated,
                        i18n_args: activation_message)
    self
  end

  private

  def default_attributes
    self.status ||= :open
  end
end
