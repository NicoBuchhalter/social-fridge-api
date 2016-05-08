class Fridge < ActiveRecord::Base
  acts_as_mappable default_units: :kms

  validates :lat, :lng, presence: true
end
