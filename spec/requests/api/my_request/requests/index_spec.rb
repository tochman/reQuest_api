# frozen_string_literal: true

RSpec.describe 'GET /api/my_requests/requests, users can see their list of requests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let!(:request) { 3.times { create(:request, requester: user) } }

  let(:user_2) { create(:user) }
  let(:credentials_2) { user_2.create_new_auth_token }
  let(:headers_2) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials_2) }

  describe 'with authentication' do
    before do
      get '/api/my_request/requests', headers: headers
    end

    describe 'successfully gets the requests' do
      it 'has a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'contains all the requests' do
        expect(response_json['requests'].length).to eq 3
      end
    end
  end

  describe 'without authentication' do
    before do
      get '/api/my_request/requests'
    end

    it 'has 401 response' do
      expect(response).to have_http_status 401
    end

    it 'responds error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'when there are no reQuests' do
    before do
      get '/api/my_request/requests', headers: headers_2
    end

    it 'has 404 response' do
      expect(response).to have_http_status 404
    end

    it 'responds error message' do
      expect(response_json['message']).to eq 'There are no reQuests to show'
    end
  end
end
