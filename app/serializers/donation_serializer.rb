class DonationSerializer < ActiveModel::Serializer
  attributes :status, :description, :pickup_time_from, :pickup_time_to

  has_one :donator
end
