class Fridge < User

  has_many :donations

  def fridge?
    true
  end
end
