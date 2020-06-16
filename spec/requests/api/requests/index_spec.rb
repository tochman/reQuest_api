# frozen_string_literal: true

RSpec.describe 'GET /request, can get all requests' do
  let(:user) { create(:user) }
  let!(:request) { 7.times { create(:request, requester: user) } }

  before do
    get '/api/requests'
  end

  describe 'successfully gets the requests' do
    it 'has a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'contains all the requests' do
      expect(response_json['requests'].length).to eq 7
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
