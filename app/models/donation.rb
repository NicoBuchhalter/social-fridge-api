class Donation < ActiveRecord::Base
  enum status: [:open, :active, :finished, :cancelled]

  belongs_to :donator
  belongs_to :volunteer
  belongs_to :fridge

  validates :donator, presence: true

  after_initialize :default_attributes

  private

  def default_attributes
    self.status ||= :open
  end
end
