# frozen_string_literal: true

RSpec.describe 'GET /request, can get all requests' do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:requester) { create(:user, email: 'requester@mail.com') }
  let!(:req) { 6.times { create(:request, requester: requester) } }
  let!(:req2) { 1.times { create(:request, requester: user) } }
  let!(:req3) { 3.times { create(:request, requester: requester, category: 'home') } }

  let!(:offer) { create(:offer, helper: user, request: Request.first) }

  describe 'without authentication' do
    before do
      get '/api/requests'
    end

    describe 'successfully gets the requests' do
      it 'has a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'contains all the requests' do
        expect(response_json['requests'].length).to eq 10
      end

      describe 'has keys' do
        it ':id' do
          expect(response_json['requests'][0]).to have_key 'id'
        end

        it ':title' do
          expect(response_json['requests'][0]).to have_key 'title'
        end

        it ':description' do
          expect(response_json['requests'][0]).to have_key 'description'
        end

        it ':category' do
          expect(response_json['requests'][0]).to have_key 'category'
        end

        it ':requester' do
          expect(response_json['requests'][0]).to have_key 'requester'
        end
      end

      describe 'does not have keys' do
        it ':created_at' do
          expect(response_json['requests'][0]).not_to have_key 'created_at'
        end
      end
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
      response_json['requests'].each do |element|
        expect(element['category']).to eq 'home'
      end
    end
  end

  describe 'with authentication' do
    before do
      @request = Request.last
      post '/api/offers',
           headers: headers,
           params: { request_id: @request.id, message: 'Hi, I can help!' }

      get '/api/requests',
          headers: headers
    end

    it 'includes the offerable key' do
      expect(response_json['requests'][0]).to have_key 'offerable'
    end

    it "offerable is false on user's own requests" do
      expect(response_json['requests'].last['offerable']).to eq false
    end

    it 'offerable is false when user has already offered on the request' do
      expect(response_json['requests'].first['offerable']).to eq false
    end
  end
end
