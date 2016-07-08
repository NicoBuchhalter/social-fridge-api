class Fridge < User
  include Locatable

  has_many :donations

  def fridge?
    true
  end
end
