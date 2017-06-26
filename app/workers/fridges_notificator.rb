class FridgesNotificator
  include HTTParty
  include Sidekiq::Worker

  base_uri Rails.application.secrets.fridges_api_url

  def perform(donation_id)
    donation = Donation.find_by_id(donation_id)
    return if donation.nil? || donation.fridge.nil? || donation.products.empty?
    self.class.post('/donations', body: { donation: serialized_donation })
  end

  private

  def serialized_donation(donation)
    {
      storage_unit_id: donation.fridge.fridges_api_id,
      name: donation.volunteer.name.split(' ').first,
      last_name: donation.volunteer.name.split(' ').second,
      delivered: false,
      donation_products_attributes: donation.products.map { |product| serialized_product(product) }
    }
  end

  def serialized_product(product)
    {
      product_type_id: product.product_type_id,
      quantity: product.quantity.round(2),
      expiration_date: product.expiration_date.strftime('%d/%m/%Y')
    }
  end
end
