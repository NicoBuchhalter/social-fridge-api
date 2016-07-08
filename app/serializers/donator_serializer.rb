class DonatorSerializer < ActiveModel::Serializer
  attributes :lat, :lng, :address, :email

  has_many :donations
end
