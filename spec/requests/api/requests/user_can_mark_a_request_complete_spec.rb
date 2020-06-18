# frozen_string_literal: true

RSpec.describe 'Api::MyRequest::Requests :update', type: :request do
  let(:user) { create(:user, email: 'user@email.com') }
  let(:user2) { create(:user, email: 'user2@email.com') }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:user2_credentials) { user2.create_new_auth_token }
  let(:user2_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(user2_credentials) }
  let(:request) { create(:request, requester: user, status: 'active') }
  let(:request_2) { create(:request, requester: user) }

  describe 'User can mark request as completed ' do
    before do
      put "/api/my_request/requests/#{request.id}", headers: headers, params: { activity: 'complete' }
      request.reload
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'changes the status of the request' do
      expect(request.status).to eq 'completed'
    end

    it 'responds with the completed confirmation' do
      expect(response_json['message']).to eq 'Request completed!'
    end
  end

  describe "User can't mark another user's request as completed" do
    before do
      put "/api/my_request/requests/#{request.id}", headers: user2_headers, params: { activity: 'complete' }
      request.reload
    end

    it 'has 422 response' do
      expect(response).to have_http_status 422
    end

    it 'cant change the status of the request' do
      expect(request.status).to eq 'active'
    end

    it 'responds with the completed confirmation' do
      expect(response_json['message']).to eq 'Something went wrong: Request not reachable'
    end
  end

  describe "User can't mark pending request completed" do
    before do
      put "/api/my_request/requests/#{request_2.id}", headers: headers, params: { activity: 'complete' }
      request_2.reload
    end

    it 'has 422 response' do
      expect(response).to have_http_status 422
    end

    it 'cant change the status of the request' do
      expect(request_2.status).to eq 'pending'
    end

    it 'responds with the completed confirmation' do
      expect(response_json['message']).to eq "Something went wrong: Can't complete a pending request"
    end
  end
end
