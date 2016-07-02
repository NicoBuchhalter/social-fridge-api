require 'rails_helper'

shared_examples_for 'locatable' do
  it { is_expected.to validate_presence_of(:lat) }
  it { is_expected.to validate_presence_of(:lng) }
  it { is_expected.to validate_presence_of(:address) }
end
