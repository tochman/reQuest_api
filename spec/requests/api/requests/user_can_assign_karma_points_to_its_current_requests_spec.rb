# frozen_string_literal: true

RSpec.describe 'POST /api/requests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'helper can afford to offer help' do
    before do
      post '/api/requests',
           headers: headers,
           params: { title: 'reQuest title', description: 'You shall come and help me!', reward: 100 }
      @quest = Request.last
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with a success message' do
      expect(response_json['message']).to eq 'Your reQuest was successfully created!'
    end
  end
end
