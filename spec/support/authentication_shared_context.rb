RSpec.shared_context 'Authentication Context' do
  let!(:user)        { create(:user) }

  before(:each) do
    request.headers['Authorization'] = user.generate_access_token
  end
end
