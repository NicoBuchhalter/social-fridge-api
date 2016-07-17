require 'rails_helper'

describe Api::V1::FridgesController do
  describe 'GET #index' do
    include_context 'Authentication Volunteer Context'

    let(:fridges_count) { 5 }
    let!(:fridges) { create_list(:fridge, fridges_count) }

    context 'when requesting for fridges' do
      let(:lat) { '-34.5808860' }
      let(:lng) { '-58.4241330' }

      before(:each) do
        get :index, lat: lat, lng: lng
      end

      it 'returns success status' do
        expect(response).to have_http_status :ok
      end

      it 'returns all its fridges' do
        expect(response_body.length).to eq fridges_count
      end

      it 'returns fridges ordered by distance' do
        f = Fridge.new(email: 'fake@fake.com', password: 'password', lat: lat, lng: lng)
        expect(f.distance_to([response_body.first['lat'], response_body.first['lng']]))
          .to be <= f.distance_to([response_body.last['lat'], response_body.last['lng']])
      end
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      before(:each) { post :create, attributes_for(:fridge) }

      it 'returns an access token' do
        expect(response_body['access_token']).to be_present
      end

      it 'returns created status' do
        expect(response).to have_http_status :created
      end
    end

    context 'when there are missing parameters' do
      before(:each) { post :create }

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns no body' do
        expect(response.body).not_to be_present
      end
    end

    context 'when fridge is not valid' do
      let(:fridge_attributes) { attributes_for(:fridge) }
      let!(:existing_fridge) { create(:fridge, email: fridge_attributes[:email]) }

      before(:each) { post :create, fridge_attributes }

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns a response with an error message' do
        expect(response_body['errors']).to be_present
      end
    end
  end
end
