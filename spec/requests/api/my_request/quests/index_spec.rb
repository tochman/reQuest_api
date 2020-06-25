# frozen_string_literal: true

RSpec.describe 'GET /api/my_requests/quests, users can see their list of quests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  let(:user_2) { create(:user) }
  let(:credentials_2) { user_2.create_new_auth_token }
  let(:headers_2) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials_2) }

  let!(:pending_quests) do
    4.times do
      request = create(:request, helper: nil, requester: user_2)
      create(:offer, request_id: request.id, helper: user, status: 'pending')
    end
  end

  let!(:active_quests) do
    5.times do
      request = create(:request, helper: user, requester: user_2, status: 'active')
      create(:offer, request_id: request.id, helper: user, status: 'accepted')
    end
  end

  let!(:completed_quests) do
    6.times do
      request = create(:request, helper: user, requester: user_2, status: 'completed')
      create(:offer, request_id: request.id, helper: user, status: 'accepted')
    end
  end

  let!(:another_pending_quest) { create(:request, helper: nil, requester: user_2) }
  let!(:antoher_active_quest) { create(:request, status: 'active') }
  let!(:another_completed_quest) { create(:request, status: 'active') }
  let!(:user_was_declined_quest) do
    request = create(:request, status: 'active')
    create(:offer, request_id: request.id, helper: user, status: 'declined')
  end

  describe 'with authentication' do
    before do
      get '/api/my_request/quests', headers: headers
    end

    describe 'successfully gets the quests' do
      it 'has a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'contains all the quests' do
        expect(response_json['quests'].length).to eq 15
      end

      it 'contains the 4 pending quests' do
        pendings = response_json['quests'].select {|req| req['status'] == 'pending' }
        expect(pendings.length).to eq 4
      end

      it 'contains the 5 active quests' do
        actives = response_json['quests'].select {|req| req['status'] == 'active'}
        expect(actives.length).to eq 5
      end

      it 'contains the 6 completed quests' do
        completeds = response_json['quests'].select {|req| req['status'] == 'completed'}
        expect(completeds.length).to eq 6
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
