RSpec.describe 'POST /message users can post messages' do
  let(:requester) { create(:user, email: 'requester@mail.com') }
  let(:req_creds) { requester.create_new_auth_token }
  let(:req_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(req_creds) }

  let(:helper) { create(:user) }
  let(:helper_credentials) { helper.create_new_auth_token }
  let(:helper_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(helper_credentials) }

  let(:third_user) { create(:user) }
  let(:third_user_credentials) { third_user.create_new_auth_token }
  let(:third_user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(third_user_credentials) }
  
  let(:request) { create(:request, requester: requester) }
  let(:offer) { create(:offer, request: request, helper: helper) }

  let!(:message) { create(:message, conversation: offer.conversation, sender: helper) }

  describe 'successfully as the requester' do
    before do
      post '/api/messages', headers: req_headers, params: { offer_id: offer.id, content: "message content" }
    end

    it 'gives a success status' do
      expect(response).to have_http_status 201
    end

    it 'creates a message based on the params' do
      offer.reload
      expect(offer.conversation.messages.last['content']).to eq "message content"
    end
  end

  describe 'successfully as the helper' do
    before do
      post '/api/messages', headers: helper_headers, params: { offer_id: offer.id, content: "message content" }
    end

    it 'gives a success status' do
      expect(response).to have_http_status 201
    end

    it 'creates a message based on the params' do
      offer.reload
      expect(offer.conversation.messages.last['content']).to eq "message content"
    end
  end

  describe 'unsuccessfully' do
    describe 'without content' do
      before do
        post '/api/messages', headers: helper_headers, params: { offer_id: offer.id }
      end

      it 'gives an error status' do
        expect(response).to have_http_status 422
      end

      it 'gives an error message' do
        expect(response_json['message']).to eq "Content can't be blank"
      end
    end

    describe 'without offer_id' do
      before do
        post '/api/messages', headers: helper_headers, params: { content: 'message content' }
      end

      it 'gives an error status' do
        expect(response).to have_http_status 422
      end

      it 'gives an error message' do
        expect(response_json['message']).to eq "Couldn't find Offer without an ID"
      end
    end

    describe 'unauthorized' do
      before do
        post '/api/messages', headers: third_user_headers, params: { offer_id: offer.id, content: 'message content' }
      end

      it 'gives an error status' do
        expect(response).to have_http_status 422
      end

      it 'gives an error message' do
        expect(response_json['message']).to eq 'You are not authorized to do this!'
      end
    end

    describe 'unauthenticated' do
      before do
        post '/api/messages', params: { offer_id: offer.id, content: 'message content' }
      end


      it 'gives an error status' do
        expect(response).to have_http_status 401
      end

      it 'gives an error message' do
        expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
