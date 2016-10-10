class Donation < ActiveRecord::Base
  # Unknown status is when we dont know if the food was delivered or not.
  enum status: [:open, :active, :finished, :cancelled, :unknown]

  belongs_to :donator
  belongs_to :volunteer
  belongs_to :fridge
  acts_as_mappable through: :donator

  validates :donator, :pickup_time_from, :pickup_time_to, presence: true

  after_initialize :default_attributes

  private

  def default_attributes
    self.status ||= :open
  end
end
