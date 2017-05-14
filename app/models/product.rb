class Product < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :donation, inverse_of: :products

  validates :donation, :product_type, :quantity, presence: true
end
