module Omniauth
  module Facebook
    module ParamsHelper
      private

      def user_fb_params(facebook_token, user, fb_info, _new_user)
        {
          name: upsert_fb_params(user, 'name', fb_info)
            .split.reduce('') { |a, e| "#{a} #{e.capitalize}" },
          email: upsert_fb_params(user, 'email', fb_info),
          fb_id: fb_info['id'],
          remote_avatar_url: fb_avatar(fb_info),
          fb_access_token: facebook_token,
          username: fb_username(user, fb_info)
        }
      end

      def upsert_fb_params(user, param, fb_info)
        user.try(param) || fb_info[param].downcase
      end

      def fb_username(user, fb_info)
        aux = user.try('username')
        return aux if aux.present?
        aux = base_username(user, fb_info).squish.downcase.tr(' ', '.')
                                          .tr('%', '')
        aux + valid_username_suffix(aux)
      end

      def base_username(user, fb_info)
        upsert_fb_params(user, 'email', fb_info).split('@').first
      end

      def fb_avatar(fb_info)
        fb_info['picture']
          .try(:[], 'data').try(:[], 'url') unless fb_info['picture']
                                                   .try(:[], 'data').try(:[], 'is_silhouette')
      end

      def valid_username_suffix(uname)
        usernames = User.where('username ILIKE :s', s: uname + '%').pluck(:username)
        actual_suffixes = usernames.map do |e|
          e.slice!(uname)
          e
        end
        find_next_suffix(actual_suffixes)
      end

      def find_next_suffix(actual_suffixes)
        return '' unless ''.in?(actual_suffixes)
        suffix = '1'
        loop do
          break "_#{suffix}" unless "_#{suffix}".in?(actual_suffixes)
          suffix = (suffix.to_i + 1).to_s # ''.to_i = 0
        end
      end
    end
  end
end
