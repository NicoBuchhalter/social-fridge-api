require 'rails_helper'

describe Api::V1::VolunteersController do
  let(:body) { JSON.parse(response.body) if response.body.present? }

  describe '#fb_connect' do
    let!(:fb_connector) do
      Koala::Facebook::TestUsers.new(
        app_id: Rails.application.secrets.facebook_app_id,
        secret: Rails.application.secrets.facebook_app_secret
      )
    end
    let!(:test_volunteer_params) { fb_connector.list.last }
    context 'When making a request without a created volunteer', :vcr do
      it 'returns http created' do
        post :fb_connect, access_token: test_volunteer_params['access_token']
        expect(response).to have_http_status :created
      end
      it 'increments the count of volunteers' do
        expect { post :fb_connect, access_token: test_volunteer_params['access_token'] }
          .to change(Volunteer, :count).by(1)
      end
    end

    context 'When making a request with a created volunteer (sign in)', :vcr do
      let!(:facebook_volunteer) do
        create(:volunteer, fb_id: test_volunteer_params['id'],
                           fb_access_token: test_volunteer_params['access_token'],
                           password: nil,
                           password_confirmation: nil)
      end
      it 'returns http ok' do
        post :fb_connect, access_token: test_volunteer_params['access_token']
        expect(response).to have_http_status :ok
      end
      it 'does not change the amount of volunteers' do
        expect { post :fb_connect, access_token: test_volunteer_params['access_token'] }
          .not_to change { Volunteer.count }
      end
    end

    context 'When making an invalid request', :vcr do
      before(:each) do
        post :fb_connect, access_token: 'invalidToken'
      end
      it 'is not success' do
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'when using a facebook account that has his email hidden', :vcr do
      let!(:invalid_test_volunteer_params) { fb_connector.list.first }
      it 'returns wrong preconditions' do
        post :fb_connect, access_token: invalid_test_volunteer_params['access_token']
        expect(response).to have_http_status :precondition_failed
      end
    end
  end
end
