# frozen_string_literal: true

RSpec.describe 'GET /api/my_requests/quests, users can see their list of quests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  let(:user_2) { create(:user) }
  let(:credentials_2) { user_2.create_new_auth_token }
  let(:headers_2) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials_2) }

  let!(:request) { 3.times { create(:request, helper: user, requester: user_2) } }

  describe 'with authentication' do
    before do
      get '/api/my_request/quests', headers: headers
    end

    describe 'successfully gets the quests' do
      it 'has a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'contains all the quests' do
        expect(response_json['quests'].length).to eq 3
      end

      describe 'has keys' do
        it ':id' do
          expect(response_json['quests'][0]).to have_key 'id'
        end

        it ':title' do
          expect(response_json['quests'][0]).to have_key 'title'
        end

        it ':reward' do
          expect(response_json['quests'][0]).to have_key 'reward'
        end
      end

      describe 'does not have keys' do
        it ':created_at' do
          expect(response_json['quests'][0]).not_to have_key 'created_at'
        end
        it ':requester' do
          expect(response_json['quests'][0]).not_to have_key 'requester'
        end
        it ':description' do
          expect(response_json['quests'][0]).not_to have_key 'description'
        end
      end
    end
  end

  describe 'without authentication' do
    before do
      get '/api/my_request/quests'
    end

    it 'has 401 response' do
      expect(response).to have_http_status 401
    end

    it 'responds error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'when there are no quests' do
    before do
      get '/api/my_request/quests', headers: headers_2
    end

    it 'has 404 response' do
      expect(response).to have_http_status 404
    end

    it 'responds error message' do
      expect(response_json['message']).to eq 'There are no quests to show'
    end
  end
end
