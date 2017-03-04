class VolunteerSerializer < ActiveModel::Serializer
  attributes :email, :name, :username, :avatar

  def avatar
    return nil if object.avatar.nil?
    { original: object.avatar.url, thumb: object.avatar.thumb.url }
  end
end
