class Donation < ActiveRecord::Base
  belongs_to :donator
  belongs_to :volunteer
  belongs_to :fridge

  validates :donator, presence: true

end
