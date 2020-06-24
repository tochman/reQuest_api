require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :offer }
    it { is_expected.to have_many :messages }
  end

  describe 'factory' do
    it 'should be valid' do
      expect(create(:conversation)).to be_valid
    end
  end
end
