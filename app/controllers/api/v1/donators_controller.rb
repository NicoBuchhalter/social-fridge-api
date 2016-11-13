module Api
  module V1
    class DonatorsController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def create
        donator = Donator.create(create_params)
        return render_errors(donator.errors.full_messages) unless donator.valid?
        render json: { access_token: donator.generate_access_token }, status: :created
      end

      def update
        current_user.update_attributes(update_params)
        return head :ok if current_user.save
        render_errors(current_user.errors)
      end

      def index
        render json: Donator.all.page(params[:page]), status: :ok
      end

      def me
        render json: current_user, status: :ok
      end

      private

      def create_params
        [:email, :password, :address, :name].each { |p| params.require(p) }
        params.permit(:email, :password, :address, :name, :avatar)
      end

      def update_params
        params.permit(:address, :name, :avatar)
      end
    end
  end
end
