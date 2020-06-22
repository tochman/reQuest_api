# frozen_string_literal: true

RSpec.describe Request, type: :model do
  let(:user) { create(:user) }

  describe 'database table' do
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :description }
    it { is_expected.to have_db_column :reward }
    it { is_expected.to have_db_column :status }
    it { is_expected.to have_db_column :category }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :reward }
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to validate_presence_of :category }

    it { is_expected.to validate_numericality_of(:reward).is_greater_than_or_equal_to(0) }

    describe 'prevents requester from updating request status to completed while pending' do
      subject { create(:request, requester: user, status: 'pending') }
      before do
        subject.status = 'completed'
        subject.valid?
      end
      it 'returns error message' do
        expect(subject.errors.full_messages).to include 'Status cannot be set to completed when it is pending'
      end

      it 'keeps pending status' do
        expect(subject.pending?).to be_truthy
      end
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to :requester }
  end

  describe 'factory' do
    it 'should be valid' do
      expect(create(:request)).to be_valid
    end
  end

  describe 'instance metthods' do
    describe '#requested_by?' do
      let(:another_user) { create(:user, email: 'another@mail.com') }
      subject { create(:request, requester: user, status: 'pending') }
      it 'returns false if user is NOT requester' do
        expect(subject.requested_by?(another_user)).to be_falsey
      end
    end
  end

  describe 'constraits' do
    describe '#validate_requester' do
      let(:another_user) { create(:user, email: 'another@mail.com') }
      subject { create(:request, requester: user, status: 'pending') }
      it 'returns false if user is NOT requester' do
        expect { subject.validate_requester(another_user) }
          .to raise_error StandardError, 'This is not your reQuest'
      end
    end
  end
end
