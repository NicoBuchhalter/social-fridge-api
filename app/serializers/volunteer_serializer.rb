class VolunteerSerializer < ActiveModel::Serializer
  attributes :email, :name, :access_token, :username

  def access_token
    object.generate_access_token
  end
end
