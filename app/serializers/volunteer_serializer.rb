class VolunteerSerializer < ActiveModel::Serializer
  attributes :email, :name, :access_token, :username, :avatar

  def avatar
    return nil if object.avatar.nil?
    { original: object.avatar.url, thumb: object.avatar.thumb.url }
  end

  def access_token
    object.generate_access_token
  end
end
