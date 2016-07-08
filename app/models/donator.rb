class Donator < User
  include Locatable

  has_many :donations

  scope :open, -> { where(id: Donation.open.select(:donator_id)) }

  def donator?
    true
  end
end
