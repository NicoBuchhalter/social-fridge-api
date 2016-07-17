RSpec.shared_context 'Authentication Fridge Context' do
  let!(:current_user) { create(:fridge) }

  before(:each) do
    request.headers['Authorization'] = current_user.generate_access_token
  end
end

RSpec.shared_context 'Authentication Volunteer Context' do
  let!(:current_user) { create(:volunteer) }

  before(:each) do
    request.headers['Authorization'] = current_user.generate_access_token
  end
end

RSpec.shared_context 'Authentication Donator Context' do
  let!(:current_user) { create(:donator) }

  before(:each) do
    request.headers['Authorization'] = current_user.generate_access_token
  end
end
