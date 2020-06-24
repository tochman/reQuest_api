# frozen_string_literal: true

RSpec.describe 'GET /request, can get all requests' do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:requester) { create(:user, email: 'requester@mail.com') }
  let!(:pending_requests)         { 6.times { create(:request, requester: requester) } }
  let!(:active_requests)          { 6.times { create(:request, requester: requester, status: "active") } }
  let!(:req_with_category_home)   { 3.times { create(:request, requester: requester, category: 'home') } }
  let!(:req_with_other_requester) { 1.times { create(:request, requester: user) } }
  let!(:req_with_offer)           { 1.times { create(:request, requester: requester) } }
  let!(:offer)                    { create(:offer, helper: user, request: Request.last) }


  describe 'without authentication' do
    before do
      get '/api/requests'
    end

    it 'has a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'contains all the pending requests (only)' do
      expect(response_json['requests'].length).to eq 11
    end
  end

  describe 'without authentication with params' do
    before do
      get '/api/requests', params: { category: 'home' }
    end
    it 'has a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'contains all the requests' do
      expect(response_json['requests'].length).to eq 3
    end

    it 'contains home category only' do
      response_json['requests'].each do |request|
        expect(request['category']).to eq 'home'
      end
    end
  end

  describe 'with authentication' do
    before do
      get '/api/requests',
          headers: headers
    end

    it "offerable is false on user's own requests" do
      expect(response_json['requests'].second['offerable']).to eq false
    end

    it 'offerable is false when user has already offered on the request' do
      expect(response_json['requests'].first['offerable']).to eq false
    end

    it "offerable is true on other requests" do
      expect(response_json['requests'].last['offerable']).to eq true
    end
  end
end
