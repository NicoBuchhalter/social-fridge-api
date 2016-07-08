class Donator < User
  include Locatable

  def donator?
    true
  end

end
