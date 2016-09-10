require 'rails_helper'

describe Donator, :vcr do
  it_behaves_like 'locatable'

  describe '#open' do
    context 'when calling open scope' do
      let!(:donator_open) { create(:donator) }
      let!(:donation) { create(:donation, donator: donator_open) }
      let!(:donator_finished) { create(:donator) }
      let!(:donation_finished) { create(:donation, donator: donator_finished, status: :finished) }

      it 'brings all donators with opened donations' do
        donators = Donator.open
        expect(donators.include?(donator_open)).to eq true
        expect(donators.include?(donator_finished)).to eq false
      end
    end
  end
end
