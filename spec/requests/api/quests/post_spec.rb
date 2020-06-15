RSpec.describe 'POST /api/quests, user can create a request', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'with valid credentials and params' do
    before do
      post '/api/quests',
           headers: headers,
           params: { title: 'Quest title', description: 'You shall come and help me!' }
      @quest = Quest.last
    end

    it 'has 200 response' do
      expect(response).to have_http_status 200
    end

    it 'responds with a success message' do
      expect(response_json['message']).to eq 'reQuest successfully created!'
    end

    it 'responds with the id of the created quest' do
      expect(response_json['id']).to eq @quest.id
    end

    it 'makes the user the requester' do
      expect(quest.requester).to eq user.id
    end
  end

  describe 'with no credentials and valid params' do
    before do
      post '/api/quests', 
           params: { title: 'Quest title', description: 'You shall come and help me!' }
    end

    it 'has 401 response' do
      expect(response).to have_http_status 401
    end

    it 'responds with an error message' do
      expect(response_json['message']).to eq 'You need to login first!'
    end
  end

  describe 'with valid credentials and invalid params' do
    before do
      post '/api/quests',
           headers: headers,
           params: {
             title: 'Questus title',
             description: 'You shall come and help me!',
             body: 'Why is this here?'
           }
    end

    it 'has 422 response' do
      expect(response).to have_http_status 422
    end

    it 'responds with an error message' do
      expect(response_json['message']).to eq 'body is not a permitted parameter'
    end
  end

  describe 'with valid credentials and missing params' do
    before do
      post '/api/quests', headers: headers, params: { title: 'Questus title' }
    end

    it 'has 422 response' do
      expect(response).to have_http_status 422
    end

    it 'responds with an error message' do
      expect(response_json['message']).to eq "Description can't be blank"
    end
  end
end