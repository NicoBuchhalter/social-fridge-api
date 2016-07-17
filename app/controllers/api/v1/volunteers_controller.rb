module Api
  module V1
    class VolunteersController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :create

      def create
        volunteer = Volunteer.create(create_params)
        return render_errors(volunteer.errors.full_messages) unless volunteer.valid?
        render json: { access_token: volunteer.generate_access_token }, status: :created
      end

      private

      def create_params
        [:email, :password, :password_confirmation].each { |param| params.require(param) }
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
