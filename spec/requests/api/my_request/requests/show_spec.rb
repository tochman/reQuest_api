# frozen_string_literal: true

RSpec.describe 'GET /api/my_request/requests/:id', type: :request do
  let(:requester) { create(:user, email: 'requester@mail.com') }
  let(:credentials) { requester.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:my_request) { create(:request, requester: requester) }
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:not_my_request) { create(:request, requester: user_1) }

  let!(:offer_1) { create(:offer, helper: user_1, request: my_request) }
  let!(:offer_2) { create(:offer, helper: user_2, request: my_request) }

  describe 'with valid credentials and params' do
    before do
      get "/api/my_request/requests/#{my_request.id}",
          headers: headers
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with correct request' do
      expect(response_json['request']['id']).to eq my_request.id
    end

    it 'responds with all offers associated with the reQuest' do
      expect(response_json['request']['offers'].length).to eq 2
    end
  end

  describe 'without valid credentials' do
    before do
      get "/api/my_request/requests/#{my_request.id}"
    end

    it 'has 401 status' do
      expect(response).to have_http_status 401
    end

    it 'responds with error message' do
      expect(response_json['errors'][0]).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe "targeting someone else's reQuest" do
    before do
      get "/api/my_request/requests/#{not_my_request.id}",
          headers: headers
    end

    it 'has 422 status' do
      expect(response).to have_http_status 422
    end

    it 'responds with error message' do
      expect(response_json['message']).to eq 'This is not your reQuest'
    end
  end
end
