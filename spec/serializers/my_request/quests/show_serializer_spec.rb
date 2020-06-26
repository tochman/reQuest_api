# frozen_string_literal: true

RSpec.describe MyRequest::Quest::ShowSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:request) { create(:request) }
  let!(:offer) { create(:offer, request: request, helper: user) }
  let!(:message) { offer.append_message('Hi, I can help') }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.last,
      serializer: described_class,
      scope: user,
      scope_name: :current_user,
      root: 'quest'
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'wraps content in key reflecting model name' do
    expect(subject.keys).to match ['quest']
  end

  it 'contains only id, title, description, email, reward, status and offers' do
    expected_keys = %w[id title description email reward status offer]
    expect(subject['quest'].keys).to match expected_keys
  end

  it 'offer contains only id, message and status' do
    expected_keys = %w[id status conversation]
    expect(subject['quest']['offer'].keys).to match expected_keys
  end

  it 'conversation has messages with keys content, me' do
    expected_keys = %w[content me]
    expect(subject['quest']['offer']['conversation']['messages'].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      'quest' => {
        'id' => an_instance_of(Integer),
        'title' => an_instance_of(String),
        'description' => an_instance_of(String),
        'email' => a_string_including('@'),
        'reward' => an_instance_of(Integer),
        'status' => an_instance_of(String),
        'offer' => {
          'id' => an_instance_of(Integer),
          'status' => an_instance_of(String),
          'conversation' => {
            'messages' => a_collection_including({
              'content' => an_instance_of(String),
              'me' => an_instance_of(TrueClass)
            })
          }
        }
      }
    )
  end
end
