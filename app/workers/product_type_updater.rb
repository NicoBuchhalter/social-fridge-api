class ProductTypeUpdater
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  include HTTParty

  base_uri Rails.application.secrets.fridges_api_url

  recurrence { hourly }

  def perform
    response = self.class.get('/product_types')
    response.parsed_response.each do |attributes|
      product_type = ProductType.find_or_initialize_by(external_id: attributes['id'])
      if product_type.new_record?
        create_product_type(product_type, attributes)
      else
        update_product_type(product_type, attributes)
      end
    end
  end

  private

  def create_product_type(new_product_type, attributes)
    new_product_type.update(
      attributes.slice('name', 'measurement_unit').merge(external_id: attributes['id'])
    )
  end

  def update_product_type(existing_product_type, attributes)
    existing_product_type.update(attributes.slice('name', 'measurement_unit'))
  end
end
