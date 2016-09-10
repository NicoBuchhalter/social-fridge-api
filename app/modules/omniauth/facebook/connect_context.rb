module Omniauth
  module Facebook
    class ConnectContext
      include ParamsHelper
      attr_accessor :facebook_token
      attr_reader :status, :volunteer, :fb_connector

      def initialize(volunteer = nil)
        @volunteer = volunteer
      end

      def handle(facebook_token)
        @facebook_token = facebook_token
        @fb_connector, fb_info = GraphAPI.fb_user_info(facebook_token)
        @status = handle_for(fb_info)
      rescue Koala::Facebook::AuthenticationError
        @status = :unauthorized
      end

      private

      def handle_for(fb_info)
        volunteer.present? ? handle_logged(fb_info) : handle_not_logged(fb_info)
      end

      def handle_connect(fb_info)
        return :forbidden if already_connected_to_other_account?(fb_info['id'])
        connect(fb_info) unless volunteer.fb_id.present?
        :ok
      end

      def handle_not_logged(fb_info)
        @volunteer = Volunteer.find_by_fb_id(fb_info['id'])
        if volunteer.present?
          :ok
        else
          new_facebook_connect(fb_info)
        end
      end

      def new_facebook_connect(fb_info)
        @volunteer = Volunteer.find_by_email(fb_info['email']) if fb_info['email'].present?
        volunteer.present? ? handle_connect(fb_info) : sign_up_user(fb_info)
      end

      def already_connected_to_other_account?(id)
        volunteer.fb_id.present? && volunteer.fb_id != id
      end

      def handle_logged(fb_info)
        return :bad_request if volunteer.fb_id.present? || User.exists?(fb_id: fb_info['id'])
        connect(fb_info)
        :ok
      end

      def sign_up_user(fb_info)
        return :precondition_failed unless fb_info['email'].present?
        create_user(fb_info)
        :created
      end

      def create_user(fb_info)
        @volunteer = Volunteer.create!(user_fb_params(facebook_token, volunteer, fb_info, true))
      end

      def connect(fb_info)
        volunteer.update_attributes!(user_fb_params(facebook_token, volunteer, fb_info, false))
      end
    end
  end
end
