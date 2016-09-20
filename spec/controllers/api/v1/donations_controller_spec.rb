require 'rails_helper'

describe Api::V1::DonationsController do
  describe 'POST #create' do
    context 'when current user is a donator' do
      include_context 'Authentication Donator Context'
      let(:params) { attributes_for(:donation) }

      it 'creates a new Donation' do
        expect { post :create, params }.to change { Donation.count }.by(1)
      end

      it 'returns created status' do
        post :create, params
        expect(response).to have_http_status :created
      end
    end

    context 'when current user is not a donator' do
      let!(:new_user) { create(:user) }
      let(:params) { attributes_for(:donation) }

      before(:each) do
        request.headers['Authorization'] = new_user.generate_access_token
        post :create, params
      end

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns an error message' do
        expect(response_body['errors']).not_to be_empty
      end
    end
  end

  describe 'POST #activate' do
    context 'when current user is a volunteer' do
      include_context 'Authentication Volunteer Context'

      let!(:donation) { create(:donation) }
      let!(:fridge) { create(:fridge) }

      before(:each) { post :activate, id: donation.id, fridge_id: fridge.id }

      it 'updates donation to active' do
        expect(donation.reload.status).to eq 'active'
      end

      it 'assigns current volunteer to the donation' do
        expect(donation.reload.volunteer).to eq current_user
      end

      it 'assigns fridge to donation' do
        expect(donation.reload.fridge).to eq fridge
      end

      it 'returns ok status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when current user is a volunteer but fridge doesnt exist' do
      include_context 'Authentication Volunteer Context'

      let!(:donation) { create(:donation) }
      let!(:fridge) { create(:fridge) }

      before(:each) { post :activate, id: donation.id, fridge_id: Fridge.count + 1 }

      it 'returns an error message' do
        expect(response_body['errors']).not_to be_empty
      end

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end
    end

    context 'when current user is not a volunteer' do
      let!(:new_user) { create(:user) }
      let!(:donation) { create(:donation) }
      let!(:fridge) { create(:fridge) }

      before(:each) do
        request.headers['Authorization'] = new_user.generate_access_token
        post :activate, id: donation.id, fridge_id: fridge.id
      end

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns an error message' do
        expect(response_body['errors']).not_to be_empty
      end
    end
  end

  describe 'POST #finish' do
    context 'when current user is a fridge' do
      include_context 'Authentication Fridge Context'

      let!(:donation) { create(:donation) }

      before(:each) { post :finish, id: donation.id }

      it 'updates donation to finished' do
        expect(donation.reload.status).to eq 'finished'
      end

      it 'assigns current fridge to the donation' do
        expect(donation.reload.fridge).to eq current_user
      end

      it 'returns ok status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when current user is not a fridge' do
      let!(:new_user) { create(:user) }
      let!(:donation) { create(:donation) }

      before(:each) do
        request.headers['Authorization'] = new_user.generate_access_token
        post :activate, id: donation.id
      end

      it 'returns bad request status' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns an error message' do
        expect(response_body['errors']).not_to be_empty
      end
    end
  end

  describe 'GET #index' do
    context 'when current user is a volunteer' do
      include_context 'Authentication Volunteer Context'

      let!(:donations) { create_list(:donation, 5, status: :open) }
      let!(:other_donation) { create(:donation, status: :active) }

      before(:each) { get :index, status: 'open' }

      it 'returns requested donations' do
        expect(response_body.count).to eq 5
      end
    end

    context 'when current user is a donator' do
      include_context 'Authentication Donator Context'
      let!(:other_donator) { create(:donator) }
      let!(:donations) { create_list(:donation, 5, status: :open, donator: current_user) }
      let!(:other_donation) { create(:donation, status: :open, donator: other_donator) }

      before(:each) { get :index, status: 'open' }

      it 'returns requested donations' do
        expect(response_body.count).to eq 5
      end
    end
  end
end
