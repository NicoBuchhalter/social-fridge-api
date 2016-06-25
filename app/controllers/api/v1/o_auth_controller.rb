module Api
  module V1
    class OAuthController < ApplicationController
      skip_before_action :current_user, :authenticate_request

      def token
        if !valid_user?
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        else
          access_token = user.generate_access_token
          render json: { access_token: access_token }, status: :ok
        end
      end

      private

      def valid_user?
        user.present? && user.valid_password?(authenticate_params[:password])
      end

      def user
        @user ||= User.find_by(email: authenticate_params[:email])
      end

      def authenticate_params
        params.require(:email)
        params.require(:password)
        params.permit(:email, :password)
      end
    end
  end
end
