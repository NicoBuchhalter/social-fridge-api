# rubocop:disable Metrics/MethodLength
module PushJsonBuilder
  module_function

  def android(message_body, data, n_type)
    {
      GCM: {
        data: {
          n_type: n_type.to_s,
          user_id: data[:from_id],
          user_name: data[:from_name],
          donation_id: data[:donation_id],
          message_body: message_body
        }
      }.to_json
    }
  end

  def ios(loc_key, loc_args, data, n_type)
    {
      json_key => {
        aps: {
          alert: { 'loc-key' => loc_key, 'loc-args' => loc_args },
          data: data,
          n_type: n_type.to_s
        }
      }.to_json
    }
  end

  private

  module_function

  def json_key
    return 'APNS_SANDBOX' if Rails.application.secrets.sns_app_arn['ios']['sandbox']
    'APNS'
  end
end
