# frozen_string_literal: true

RSpec.describe Offer, type: :model do
  describe 'database table' do
    it { is_expected.not_to have_db_column :message }
    it { is_expected.to have_db_column :request_id }
    it { is_expected.to have_db_column :helper_id }
    it { is_expected.to have_db_column :status }
  end

  describe 'relations' do
    it { is_expected.to belong_to :helper }
    it { is_expected.to belong_to :request }
    it { is_expected.to have_one :conversation }
  end

  describe 'factory' do
    it 'should be valid' do
      expect(create(:offer)).to be_valid
    end
  end

  describe 'hooks/callbacks' do
    describe 'before_save #validate_offer_creator' do
      let(:requester) { create(:user) }
      let(:request) { create(:request, requester: requester) }

      it 'prevents requester from becoming an helper on own request' do
        expect do
          create(:offer, request: request, helper: requester)
        end
          .to raise_error StandardError, 'You cannot offer help on your own request!'
      end
    end
  end
end
