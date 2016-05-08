module Api
  module V1
    class FridgesController < ApplicationController
      def index
        render json: Fridge.by_distance(origin: current_location).page(params[:page])
      end
    end
  end
end
