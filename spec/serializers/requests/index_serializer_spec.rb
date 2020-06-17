# frozen_string_literal: true

RSpec.describe Request::IndexSerializer, type: :serializer do
  let!(:requests) { 5.times { create(:request) } }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      Request.all,
      each_serializer: Request::IndexSerializer
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'contains id, title, description, requester' do
    expected_keys = %w[id title description requester]
    expect(subject.first.keys).to match expected_keys
  end

  it 'does not contain created_at and updated_at' do
    excluded_keys = %w[created_at updated_at]
    expect(subject.first.keys).not_to match excluded_keys
  end
end
