module Locatable
  extend ActiveSupport::Concern

  included do
    acts_as_mappable default_units: :kms

    before_validation :locate

    validates :lat, :lng, :address, presence: true, unless: :volunteer?
  end

  private

  def locate
    return locate_lat_and_lng if address_changed?
    locate_address if lat_changed? || lng_changed?
  end

  def locate_address
    geo = Geokit::Geocoders::GoogleGeocoder.reverse_geocode("#{lat}, #{lng}")
    return self.address = geo.full_address if geo.success?
    errors.add(:address, 'Could not locate address by latitude and longitude')
  end

  def locate_lat_and_lng
    geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
    unless geo.success?
      return errors.add(:address, 'Could not locate latitude and longitude by address')
    end
    self.lat = geo.lat
    self.lng = geo.lng
  end
end
