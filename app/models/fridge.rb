class Fridge < ActiveRecord::Base
  has_one :location, as: :locatable
  acts_as_mappable through: :location
end
