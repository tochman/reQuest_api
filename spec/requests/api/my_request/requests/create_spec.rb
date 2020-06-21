# frozen_string_literal: true

RSpec.describe 'POST /api/my_request/requests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'with valid credentials and params' do
    before do
      post '/api/my_request/requests',
           headers: headers,
           params: { title: 'reQuest title', description: 'You shall come and help me!', reward: 100 }
      @quest = Request.last
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with a success message' do
      expect(response_json['message']).to eq 'Your reQuest was successfully created!'
    end

    it 'responds with the id of the created reQuest' do
      expect(response_json['id']).to eq @quest.id
    end

    it 'responds with the karma point left' do
      expect(response_json['karma_points']).to eq 0
    end

    it 'makes the user the requester' do
      expect(@quest.requester).to eq user
    end

    it 'has the default category' do
      expect(@quest.category).to eq 'other'
    end
  end

  describe 'user can set a valid category' do
    before do
      post '/api/my_request/requests',
           headers: headers,
           params: {
             title: 'reQuest title',
             description: 'You shall come and help me!',
             reward: 100,
             category: 'home'
           }
      @quest = Request.last
    end

    it 'and the request gets that category' do
      expect(@quest[:category]).to eq 'home'
    end
  end

  describe 'user cannot set an invalid category' do
    before do
      post '/api/my_request/requests',
           headers: headers,
           params: {
             title: 'reQuest title',
             description: 'You shall come and help me!',
             reward: 100,
             category: 'car'
           }
      @quest = Request.last
    end
    
    it 'gives an error code' do
      expect(response).to have_http_status 422
    end

    it 'gives an error message' do
      expect(response_json['message']).to eq "'car' is not a valid category"
    end
  end

  describe 'unsuccessfully' do
    describe 'with no credentials and valid params' do
      before do
        post '/api/my_request/requests',
             params: { title: 'reQuest title', description: 'You shall come and help me!', reward: 100 }
      end

      it 'has 401 response' do
        expect(response).to have_http_status 401
      end

      it 'responds with an error message' do
        expect(response_json['errors'][0]).to eq 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'with valid credentials and sevral missing params' do
      before do
        post '/api/my_request/requests', headers: headers, params: { title: 'reQuestus title' }
      end

      it 'has 422 response' do
        expect(response).to have_http_status 422
      end

      it 'responds with an error message' do
        expect(response_json['message']).to eq "Description can't be blank, Reward can't be blank, and Reward is not a number"
      end
    end

    describe 'with valid credentials and sevral missing params' do
      before do
        post '/api/my_request/requests',
             headers: headers,
             params: {
               title: 'reQuestus title',
               description: 'You shall come and help me!'
             }
      end
      it 'has 422 response' do
        expect(response).to have_http_status 422
      end

      it 'responds with an error message' do
        expect(response_json['message']).to eq "Reward can't be blank and Reward is not a number"
      end
    end

    describe 'user dont have enough karma_points' do
      before do
        post '/api/my_request/requests',
             headers: headers,
             params: {
               title: 'reQuestus title',
               description: 'You shall come and help me!',
               reward: 200
             }
      end
      it 'has 422 response' do
        expect(response).to have_http_status 422
      end

      it 'responds with an error message' do
        expect(response_json['message']).to eq 'You dont have enough karma points'
      end
    end
  end
end
