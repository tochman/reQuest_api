# frozen_string_literal: true

RSpec.describe Request::IndexSerializer, type: :serializer do
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

  it 'contains id, title, description, requester offerable reward' do
    expected_keys = %w[id title description requester offerable reward]
    expect(subject["requests"].first.keys).to match expected_keys
  end

  it 'does not contain created_at and updated_at' do
    excluded_keys = %w[created_at updated_at]
    expect(subject["requests"].first.keys).not_to match excluded_keys
  end
end
