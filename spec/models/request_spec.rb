# frozen_string_literal: true

RSpec.describe Request, type: :model do
  let(:user) { create(:user) }

  describe 'database table' do
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :description }
    it { is_expected.to have_db_column :reward }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :reward }
  end

  describe 'relations' do
    it { is_expected.to belong_to :requester }
  end

  describe 'factory' do
    it 'should be valid' do
      expect(create(:request)).to be_valid
    end
  end
end
