# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'relations' do
    it { is_expected.to have_many :requests }
  end

  describe 'db column' do
    it { is_expected.to have_db_column :karma_points }
  end

  describe 'default karma_points' do
    let(:user) { create(:user) }
    it { expect(user.karma_points).to eq 100 }
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(create(:user)).to be_valid
    end
  end
end
