# frozen_string_literal: true

RSpec.describe MyRequest::Request::ShowSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:request) { create(:request) }
  let!(:offer) { create(:offer, request: request)}
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
    expect(subject.keys).to match ["request"]
  end

  it 'contains only id, title, description, reward, status and offers' do
    expected_keys = %w[id title description reward status offers]
    expect(subject["request"].keys).to match expected_keys
  end

  it 'offer contains only id, email, message and status' do
    expected_keys = %w[id email message status]
    expect(subject["request"]["offers"].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      "request" => {
        "id" => an_instance_of(Integer),
        "title" => an_instance_of(String),
        "description" => an_instance_of(String),
        "reward" => an_instance_of(Integer),
        "status" => an_instance_of(String),
        "offers" => a_collection_including({
          "id" => an_instance_of(Integer),
          "email" => a_string_including("@"),
          "message" => an_instance_of(String),
          "status" => an_instance_of(String)
        })
      }
    )
  end
end
