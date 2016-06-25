class Donator < User
  acts_as_mappable default_units: :kms,
                   auto_geocode: { field: :address,
                                   error_message: 'Could not geocode address' }

  validates :lat, :lng, presence: true
end
