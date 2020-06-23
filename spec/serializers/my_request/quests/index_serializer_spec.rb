# frozen_string_literal: true

RSpec.describe MyRequest::Quest::IndexSerializer, type: :serializer do
  let(:user) { create(:user) }
  let!(:quests) { 
    5.times { 
      request = create(:request) 
      create(:offer, request: request, helper: user, status: "accepted") 
    }
    return Request.all
  }
  
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.all,
      each_serializer: described_class,
      scope: user,
      scope_name: :current_user,
      root: 'quests'
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'when called with root: "quests", wraps content in key reflecting requested resource' do
    expect(subject.keys).to match ["quests"]
  end

  it 'contains only id, title, description, reward, status and requester' do
    expected_keys = %w[id title description reward status requester]
    expect(subject["quests"].first.keys).to match expected_keys
  end

  it 'has a specific structure' do
    expect(subject).to match(
      "quests" => a_collection_including({
        "id" => an_instance_of(Integer),
        "title" => an_instance_of(String),
        "description" => an_instance_of(String),
        "reward" => an_instance_of(Integer),
        "status" => an_instance_of(String),
        "requester" => a_string_including('@')
      })
    )
  end
end
