class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true
  acts_as_mappable default_units: :kms

  validates :locatable_id, :locatable_type, :lat, :lng, presence: true
end
