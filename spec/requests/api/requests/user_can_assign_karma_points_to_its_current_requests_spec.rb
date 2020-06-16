# frozen_string_literal: true

RSpec.describe 'GET /api/karma_points/:id :show', type: :request do
  let(:request) { create(:request) }
  let(:user) { create(:user, email: 'user@email.com') }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'helper can afford to offer help' do
    before do
      get "/api/karma_points/#{request.id}", headers: headers
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with a true' do
      expect(response_json['karma_points']).to eq true
    end
  end
  describe 'helper dont have enough karma points' do
    let(:request) { create(:request, reward: 200) }
    before do
      get "/api/karma_points/#{request.id}", headers: headers
    end

    it '422 response' do
      expect(response).to have_http_status 422
    end

    it 'responds with false' do
      expect(response_json['karma_points']).to eq false
    end
  end
end
