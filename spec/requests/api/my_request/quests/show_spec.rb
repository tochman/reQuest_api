# frozen_string_literal: true

RSpec.describe 'GET /api/my_request/quests/:id', type: :request do
  let(:helper) { create(:user) }
  let(:helper_credentials) { helper.create_new_auth_token }
  let(:helper_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(helper_credentials) }

  let(:requester) { create(:user) }

  let(:my_quest) { create(:request, requester: requester, helper: helper) }

  let(:not_my_quest) { create(:request) }

  let!(:offer) { create(:offer, helper: helper, request: my_quest ) }

  let!(:message_1) { offer.conversation.messages.create(content: "message1", sender: requester) }
  let!(:message_2) { offer.conversation.messages.create(content: "message2", sender: helper) }

  describe 'with valid credentials and params' do
    before do
      get "/api/my_request/quests/#{my_quest.id}",
          headers: helper_headers
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with correct quest' do
      expect(response_json['quest']['id']).to eq my_quest.id
    end

    it 'the conversation has messages that show content' do
      expect(response_json['quest']['offer']['conversation']['messages'].length).to eq 2
    end

    it 'and you can see if you are the sender of the message' do
      expect(response_json['quest']['offer']['conversation']['messages'].first['me']).to eq false
    end

    it 'and you can see if you are not the sender of the message' do
      expect(response_json['quest']['offer']['conversation']['messages'].last['me']).to eq true
    end
  end

  describe 'without valid credentials' do
    before do
      get "/api/my_request/quests/#{my_quest.id}"
    end

    it 'has 401 status' do
      expect(response).to have_http_status 401
    end

    it 'responds with error message' do
      expect(response_json['errors'][0]).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe "targeting someone else's quest" do
    before do
      get "/api/my_request/quests/#{not_my_quest.id}",
          headers: helper_headers
    end

    it 'has 422 status' do
      expect(response).to have_http_status 422
    end

    it 'responds with error message' do
      expect(response_json['message']).to eq 'This is not your Quest'
    end
  end
end
