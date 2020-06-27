require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'database table' do
    it { is_expected.to have_db_column :content }
    it { is_expected.to have_db_column :sender_id }
    it { is_expected.to have_db_column :conversation_id }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :content }
  end

  describe 'relations' do
    it { is_expected.to belong_to :conversation }
    it { is_expected.to belong_to :sender }
  end

  describe 'factory' do
    it 'should be valid' do
      expect(create(:message)).to be_valid
    end
  end

  describe 'broadcast' do
    it 'should broadcast after creation' do
      message = create(:message)
      expect {
        message.save
      }.to have_broadcasted_to("offer_conversation_#{Message.last.conversation.offer.id}")
    end
  end
end
