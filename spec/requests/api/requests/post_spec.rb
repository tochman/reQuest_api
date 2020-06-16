# frozen_string_literal: true

RSpec.describe 'POST /api/requests', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'with valid credentials and params' do
    before do
      post '/api/requests',
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

    it 'makes the user the requester' do
      expect(@quest.requester).to eq user
    end
  end

  describe 'unsuccessfully' do
    describe 'with no credentials and valid params' do
      before do
        post '/api/requests',
             params: { title: 'reQuest title', description: 'You shall come and help me!', reward: 100 }
      end
      

      it 'has 401 response' do
        expect(response).to have_http_status 401
      end

      it 'responds with an error message' do
        expect(response_json['errors'][0]).to eq 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'with valid credentials and invalid params' do
      before do
        post '/api/requests',
             headers: headers,
             params: {
               title: 'reQuestus title',
               description: 'You shall come and help me!',
               body: 'Why is this here?'
             }
      end

      it 'has 422 response' do
        expect(response).to have_http_status 422
      end

      it 'responds with an error message' do
        expect(response_json['message']).to eq 'found unpermitted parameter: :body'
      end
    end

    describe 'with valid credentials and missing params' do
      before do
        post '/api/requests', headers: headers, params: { title: 'reQuestus title' }
      end

      it 'has 422 response' do
        expect(response).to have_http_status 422
      end

      it 'responds with an error message' do
        expect(response_json['message']).to eq "Description, Reward can't be blank"
      end
    end
  end
end
