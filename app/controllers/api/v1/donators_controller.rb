module Api
  module V1
    class DonatorsController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def create
        donator = Donator.create(create_params)
        return render_errors(donator.errors.full_messages) unless donator.valid?
        render json: { access_token: donator.generate_access_token }, status: :created
      end

      def index
        donators = Donator.open.by_distance(origin: current_location).page(params[:page])
        render json: donators, status: :ok
      end

      private

      def create_params
        [:email, :password, :password_confirmation, :address].each { |p| params.require(p) }
        params.permit(:email, :password, :password_confirmation, :address)
      end
    end
  end
end
