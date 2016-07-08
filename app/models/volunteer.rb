class Volunteer < User
  has_many :donations

  def volunteer?
    true
  end
end
