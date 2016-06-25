
module Api
  module V1
    class VolunteersController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def create
        volunteer = Volunteer.create(create_params)
        unless volunteer.valid?
          return render json: { errors: volunteer.errors.full_messages }, status: :bad_request
        end
        render json: { access_token: volunteer.generate_access_token }, status: :created
      end

      private

      def create_params
        [:email, :password, :password_confirmation].each do |param|
          params.require(param)
        end
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
