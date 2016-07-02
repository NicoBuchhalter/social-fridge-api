require 'rails_helper'

describe Api::V1::OAuthController do
  describe '#token' do
    let!(:user) { create(:user) }

    context 'When authenticating a valid user by email and password' do
      before(:each) do
        post :token, email: user.email, password: user.password
      end

      it 'returns a token' do
        expect(JSON.parse(response.body)['access_token']).to be_present
      end
    end

    context 'When authenticating an non existent user by email, password' do
      let!(:invalid_email) { 'test+social-fridge-invalid@nicobuch.com.ar' }
      let!(:invalid_password) { Faker::Lorem.characters(6) }

      before(:each) do
        post :token, email: invalid_email, password: invalid_password
      end

      it 'returns a response with an error message' do
        expect(JSON.parse(response.body)['error']).to be_present
      end

      it 'returns unauthorized status' do
        expect(response.status).to eq 401
      end
    end

    context 'When authenticating user with missing_parameters' do
      before(:each) do
        post :token
      end

      it 'returns bad request status' do
        expect(response.status).to eq 400
      end

      it 'returns a response with an error message' do
        expect(response.body).not_to be_present
      end
    end
  end
end
