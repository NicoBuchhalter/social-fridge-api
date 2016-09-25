class DonatorSerializer < ActiveModel::Serializer
  attributes :lat, :lng, :address, :email, :avatar, :name

  def avatar
    return nil if object.avatar.nil?
    { original: object.avatar.url, thumb: object.avatar.thumb.url }
  end
end
