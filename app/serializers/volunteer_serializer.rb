class VolunteerSerializer < ActiveModel::Serializer
  attributes :email, :name, :username, :avatar, :average_qualification

  def avatar
    return nil if object.avatar.nil?
    { original: object.avatar.url, thumb: object.avatar.thumb.url }
  end

  def average_qualification
    return 0 if object.qualifications_count.zero?
    (object.qualifications_total.to_f / object.qualifications_count.to_f).round(2)
  end
end
