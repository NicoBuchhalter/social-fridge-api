class Product < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :donation

  validates :donation, :product_type, :expiration_date, :quantity, presence: true
end
