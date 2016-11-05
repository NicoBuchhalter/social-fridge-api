module Api
  module V1
    class OAuthController < ApplicationController
      skip_before_action :current_user, :authenticate_request, only: :token

      def token
        if valid_user?
          access_token = user.generate_access_token
          render json: { access_token: access_token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def save_token
        SaveTokenWorker.perform_async(save_token_params.merge(user_id: current_user.id))
        render status: result[:status], json: result[:json]
      end

      private

      def save_token_params
        params.require(:device_type)
        params.require(:device_token)
        params.permit(:device_token, :device_type)
      end

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
