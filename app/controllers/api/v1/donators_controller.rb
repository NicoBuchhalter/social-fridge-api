module Api
  module V1
    class DonatorsController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def create
        donator = Donator.create(create_params)
        unless donator.valid?
          return render json: { errors: donator.errors.full_messages }, status: :bad_request
        end
        render json: { access_token: donator.generate_access_token }, status: :created
      end

      private

      def create_params
        [:email, :password, :password_confirmation, :address].each { |p| params.require(p) }
        params.permit(:email, :password, :password_confirmation, :address)
      end
    end
  end
end
