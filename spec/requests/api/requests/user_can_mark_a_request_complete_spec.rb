# frozen_string_literal: true

RSpec.describe 'Api::MyRequest::Requests :update', type: :request do
  let!(:user) { create(:user, email: 'user@email.com') }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let!(:request) { create(:request, requester: user) }

  describe 'User can mark request as completed ' do
    before do
      put "/api/my_request/requests/#{request.id}", headers: headers, params: { activity: 'complete' }
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
end
