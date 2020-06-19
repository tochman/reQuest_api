# frozen_string_literal: true

RSpec.describe 'GET /api/my_request/requests/:id', type: :request do
  let!(:requester) { create(:user, email: 'requester@mail.com')}
  let!(:credentials) { requester.create_new_auth_token }
  let!(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let!(:myrequest) { create(:request, requester: requester) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:notmyrequest) { create(:request, requester: user1) }

  let!(:offer1) { create(:offer, helper: user1, request: myrequest) }
  let!(:offer2) { create(:offer, helper: user2, request: myrequest) }

  describe 'with valid credentials and params' do
    before do
      get "/api/my_request/requests/#{myrequest.id}",
        headers: headers
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with id' do
      expect(response_json['id']).to eq myrequest.id
    end

    it 'responds with title' do
      expect(response_json['title']).to eq myrequest.title
    end

    it 'responds with description' do
      expect(response_json['description']).to eq myrequest.description
    end

    it 'responds with all offers associated with the reQuest' do
      expect(response_json['offers'].length).to eq 2
    end
  end

  describe 'without valid credentials' do
    before do
      get "/api/my_request/requests/#{myrequest.id}"
    end

    it 'has 401 status' do
      expect(response).to have_http_status 401
    end
  end

  describe "targeting someone else's reQuest" do
    before do
      get "/api/my_request/requests/#{notmyrequest.id}",
        headers: headers
    end

    it 'has 401 status' do
      expect(response).to have_http_status 401
    end
  end 
end