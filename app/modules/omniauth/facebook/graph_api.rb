module Omniauth
  module Facebook
    class GraphAPI
      REQUIRED_FB_PARAMS = %w(id name email).freeze

      def self.fb_user_info(fb_token)
        fb_connector = Koala::Facebook::API.new(fb_token,
                                                Rails.application.secrets.facebook_app_secret)
        [fb_connector, fb_connector.get_object('me?fields=' + REQUIRED_FB_PARAMS.join(','),
                                               type: :large)]
      end

      def self.fb_user_friends(fb_token)
        fb_connector = Koala::Facebook::API.new(fb_token,
                                                Rails.application.secrets.facebook_app_secret)
        fb_connector.get_connection('me', 'friends')
      end
    end
  end
end
