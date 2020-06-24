# frozen_string_literal: true

RSpec.describe MyRequest::Request::IndexSerializer, type: :serializer do
  let(:user) { create(:user) }
  let!(:requests) { 5.times { create(:request) } }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.all,
      each_serializer: described_class,
      scope: user,
      scope_name: :current_user
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'wraps content in key reflecting model name' do
    expect(subject.keys).to match ["requests"]
  end

  it 'contains only id, title, reward and status' do
    expected_keys = %w[id title reward status]
    expect(subject["requests"].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      "requests" => a_collection_including({
        "id" => an_instance_of(Integer),
        "title" => an_instance_of(String),
        "reward" => an_instance_of(Integer),
        "status" => an_instance_of(String)
      })
    )
  end
end