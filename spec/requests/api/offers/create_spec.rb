RSpec.describe 'POST /offers, user can offer to help' do
  let(:requester) { create(:user) }
  let(:helper) { create(:user) }
  let(:credentials) { helper.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:request) { create(:request, requester: requester)}

  describe 'with authentication and correct params' do
    before do
      post '/api/offers',
           headers: headers,
           params: { request_id: request.id, message: "Hi, I can help!" }
    end

    it 'responds with status 200' do
      expect(response).to have_http_status 200
    end

    it 'responds with a success message' do
      expect(response['message']).to eq "Your offer has been sent!"  
    end

    describe 'it creates an offer with' do
      before do
        @offer = Offer.last  
      end

      it 'the sending user as helper' do
        expect(@offer.helper).to eq helper
      end

      it 'the request it is associated with' do
        expect(@offer.request).to eq request
      end

      it 'the message' do
        expect(@offer.message).to eq "Hi, I can help!"
      end
    end
  end

  describe 'user has already offered to help' do

  end

  describe 'without authentication but correct params' do

  end

  describe 'with authenticaiton and bad params' do

  end
end