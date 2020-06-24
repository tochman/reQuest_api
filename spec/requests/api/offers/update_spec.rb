# frozen_string_literal: true

RSpec.describe 'PUT /api/offers/:id', type: :request do
  let(:requester) { create(:user) }
  let(:requester_credentials) { requester.create_new_auth_token }
  let(:requester_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(requester_credentials) }

  let(:request) { create(:request, requester_id: requester.id) }
  let(:helper) { create(:user) }
  let(:offer) { create(:offer, status: 'pending', request_id: request.id, helper_id: helper.id) }

  describe 'requester successfully' do
    describe 'accepts offer' do
      before do
        put "/api/offers/#{offer.id}",
            headers: requester_headers,
            params: { activity: 'accepted' }
        request.reload
        offer.reload
      end

      it 'has 200 response' do
        expect(response).to have_http_status 200
      end

      it 'responds offer message' do
        expect(response_json['message']).to eq "You accepted help from #{helper.email}"
      end

      it 'sets the status of the request to "active"' do
        expect(request.status).to eq "active"
      end

      it 'sets the status of the offer to "accepted"' do
        expect(offer.status).to eq "accepted"
      end

      it 'sets the helper of the request to be the one that offered help' do
        expect(request.helper).to eq helper
      end
    end

    describe 'declines offer' do
      before do
        put "/api/offers/#{offer.id}",
            headers: requester_headers,
            params: { activity: 'declined' }
        request.reload
      end

      it 'responds offer message' do
        expect(response_json['message']).to eq "You declined help from #{helper.email}"
      end

      it 'the status of the request is still "pending"' do
        expect(request.status).to eq "pending"
      end

      it 'does not assign any helper to the request' do
        expect(request.helper).to eq nil
      end
    end
  end

  describe 'unsuccessfully when' do
    describe 'offer cant be found' do
      before do
        put '/api/offers/1000',
            headers: requester_headers,
            params: { activity: 'declined' }
      end

      it 'has 500 response' do
        expect(response).to have_http_status 500
      end

      it 'responds error message' do
        expect(response_json['error_message']).to eq "Couldn't find Offer with 'id'=1000"
      end
    end

    describe 'no activity params is sent' do
      before do
        put "/api/offers/#{offer.id}",
            headers: requester_headers
      end

      it 'has 500 response' do
        expect(response).to have_http_status 500
      end

      it 'responds error message' do
        expect(response_json['error_message']).to eq 'The activty is not valid'
      end
    end

    describe 'user is not logged in' do
      before do
        put "/api/offers/#{offer.id}"
      end

      it 'has 401 response' do
        expect(response).to have_http_status 401
      end

      it 'responds error message' do
        expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'does not send in valid status' do
      before do
        put "/api/offers/#{offer.id}",
            headers: requester_headers,
            params: { activity: 'invalid status' }
      end

      it 'has 500 response' do
        expect(response).to have_http_status 500
      end

      it 'responds error message' do
        expect(response_json['error_message']).to eq 'The activty is not valid'
      end
    end
  end
end
