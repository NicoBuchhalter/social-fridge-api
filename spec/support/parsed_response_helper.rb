module Response
  module JSONParser
    def response_body
      ActiveSupport::JSON.decode(response.body) if response.present?
    end

    def serialize(instance, serializer, root_key)
      JSON.parse(serializer.new(instance).as_json[root_key].to_json)
    end
  end
end
