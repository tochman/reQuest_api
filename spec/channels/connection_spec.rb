# frozen_string_literal: true

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }
  it 'successfully connects' do
    connect "/cable?uid=#{user.email}"
    expect(connection.current_user).to eq user
  end

  it 'rejects connection' do
    expect { connect '/cable' }.to have_rejected_connection
  end
end
