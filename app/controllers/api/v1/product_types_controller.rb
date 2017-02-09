module Api
  module V1
    class ProductTypesController < ApplicationController
      def index
        render json: ProductType.all
      end
    end
  end
end
