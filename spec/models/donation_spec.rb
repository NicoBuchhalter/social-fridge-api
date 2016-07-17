require 'rails_helper'

describe Donation do
  it { is_expected.to validate_presence_of(:donator) }
  it { is_expected.to belong_to(:donator) }
  it { is_expected.to belong_to(:volunteer) }
  it { is_expected.to belong_to(:fridge) }

  describe '#default_attributes' do
    context 'when initializing a new donation' do
      it 'has open status' do
        expect(Donation.new.status).to eq 'open'
      end
    end
  end
end
