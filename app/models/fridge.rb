class Fridge < User
  include Locatable

  def fridge?
    true
  end

end
