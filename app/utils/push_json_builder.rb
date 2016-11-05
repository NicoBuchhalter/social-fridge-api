module PushJsonBuilder
  module_function

  def android(name, message_body, from_id)
    {
      GCM: {
        data: {
          user_id: from_id,
          message_body: message_body,
          name: name
        }
      }.to_json
    }
  end

  def ios(loc_key, loc_args, data)
    {
      json_key => {
        aps: {
          alert: { 'loc-key' => loc_key, 'loc-args' => loc_args },
          data: data
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
