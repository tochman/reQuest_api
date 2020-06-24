# frozen_string_literal: true

RSpec.describe MyRequest::Request::ShowSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:request) { create(:request) }
  let!(:offer) { create(:offer, request: request) }
  let!(:message) { offer.append_message('Hi, I can help') }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.last,
      serializer: described_class,
      scope: user,
      scope_name: :current_user
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'wraps content in key reflecting model name' do
    expect(subject.keys).to match ['request']
  end

  it 'contains only id, title, description, reward, status and offers' do
    expected_keys = %w[id title description reward status offers]
    expect(subject['request'].keys).to match expected_keys
  end

  it 'offer contains only id, email, message and status' do
    expected_keys = %w[id email status conversation]
    expect(subject['request']['offers'].first.keys).to match expected_keys
  end

  it 'conversation has messages with keys content, me' do
    expected_keys = %w[content me]
    expect(subject['request']['offers'].first['conversation']['messages'].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      'request' => {
        'description' => an_instance_of(String),
        'id' => an_instance_of(Integer),
        'reward' => an_instance_of(Integer),
        'status' => an_instance_of(String),
        'title' => an_instance_of(String),
        'offers' => a_collection_including({
          'email' => a_string_including('@'),
          'id' => an_instance_of(Integer),
          'status' => an_instance_of(String),
          'conversation' => {
            'messages' => a_collection_including({
              'content' => an_instance_of(String),
              'me' => an_instance_of(FalseClass)
            })
          }
        })
      }
    )
  end
end
