# frozen_string_literal: true

RSpec.describe Request::IndexSerializer, type: :serializer do
  let(:user) { create(:user) }
  let!(:requests) { 5.times { create(:request) } }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.all,
      each_serializer: described_class,
      coordinates: [2.2, 5.5],
      scope: user,
      scope_name: :current_user
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'wraps content in key reflecting model name' do
    expect(subject.keys).to match ["requests"]
  end

  it 'contains only id, title, description, requester, offerable reward and category' do
    expected_keys = %w[id title description requester offerable reward category distance]
    expect(subject["requests"].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      "requests" => a_collection_including({
        "id" => an_instance_of(Integer),
        "title" => an_instance_of(String),
        "description" => an_instance_of(String),
        "requester" => an_instance_of(String),
        "reward" => an_instance_of(Integer),
        "offerable" => (an_instance_of(TrueClass) || an_instance_of(FalseClass) || an_instance_of(NilClass)),
        "category" => an_instance_of(String),
        "distance" => an_instance_of(Float)
      })
    )
  end
end
