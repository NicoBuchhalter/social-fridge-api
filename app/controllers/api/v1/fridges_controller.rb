module Api
  module V1
    class FridgesController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def index
        render json: Fridge.by_distance(origin: current_location).page(params[:page])
      end

      def create
        fridge = Fridge.create(create_params)
        unless fridge.valid?
          return render json: { errors: fridge.errors.full_messages }, status: :bad_request
        end
        render json: { access_token: fridge.generate_access_token }, status: :created
      end

      private

      def create_params
        [:email, :password, :password_confirmation, :address].each { |p| params.require(p) }
        params.permit(:email, :password, :password_confirmation, :address)
      end
    end
  end
end
