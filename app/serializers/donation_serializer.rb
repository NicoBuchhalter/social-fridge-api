class DonationSerializer < ActiveModel::Serializer
  attributes :status, :description, :pickup_time_from, :pickup_time_to, :id, :activated_at,
             :lat, :lng, :address

  has_one :donator
  has_one :volunteer
  has_one :fridge
end
