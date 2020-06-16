# frozen_string_literal: true

RSpec.describe 'GET /api/karma_points/:id :show', type: :request do
  let(:request) { create(:request) }
  let(:user) { create(:user, email: 'user@email.com') }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'user can see karma points' do
    before do
      get "/api/karma_points", headers: headers
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with the amount' do
      expect(response_json['karma_points']).to eq 100
    end
  end
end
