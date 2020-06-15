RSpec.describe User, type: :model do
  describe 'relations' do
    it { is_expected.to have_many :quests }
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(create(:user)).to be_valid
    end
  end
end
