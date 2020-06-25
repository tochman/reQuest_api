RSpec.describe 'GET /api/requests, distance to request is displayed' do
  let!(:falun) { create(:request, long: 15.596, lat: 60.604 ) }
  let!(:leksand) { create(:request, long: 15.0, lat: 60.732 ) }
  let!(:mora) { create(:request, long: 14.48, lat: 61.0 ) }

  describe 'with location parameters, requester in mora' do
    before do
      get '/api/requests',
      params: { coordinates: { long: 14.48, lat: 61.0 }}
    end

    it 'calculates the distance correctly' do
      expect(response_json['requests'][0]['distance']).to be_within(0.1).of(0)
      expect(response_json['requests'][1]['distance']).to be_within(2).of(39.8)
      expect(response_json['requests'][2]['distance']).to be_within(3).of(74.2)
    end
  end

  describe 'with location parameters, requester in gävle' do
    before do
      get '/api/requests',
      params: { coordinates: { long: 17.141, lat: 60.675 }}
    end

    it 'calculates the distance correctly' do
      expect(response_json['requests'][0]['distance']).to be_within(4).of(145.75)
      expect(response_json['requests'][1]['distance']).to be_within(3).of(116.8)
      expect(response_json['requests'][2]['distance']).to be_within(2).of(82.75)
    end
  end

  describe 'with location parameters and category' do
    before do
      get '/api/requests',
      params: { coordinates: { long: 14.48, lat: 61.0 }, category: 'education' }
    end

    it 'gives the requests it should' do
      expect(response_json['requests'].length).to eq 3
    end
  end

  describe 'without location parameters' do
    before do
      get '/api/requests'
    end

    it 'returns distance as nil' do
      expect(response_json['requests'][0]['distance']).to eq nil
    end
  end

  describe 'with partial location parameters' do
    before do
      get '/api/requests',
          params: { coordinates: { long: 33 } }
    end

    it 'returns distance as nil' do
      expect(response_json['requests'][0]['distance']).to eq nil
    end
  end

  describe 'with bad location parameters' do
    before do
      get '/api/requests',
          params: { coordinates: { long: 190, lat: 99.0 }}
    end

    it 'returns distance as nil' do
      expect(response_json['requests'][0]['distance']).to eq nil
    end
  end
end