# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfferConversationChannel, type: :channel do
  describe 'subscription' do
    describe 'valid parameters' do
      it {
        subscribe(data: { offer_id: 234 })
        expect(subscription).to be_confirmed
      }
    end

    describe 'without valid params' do
      before do
        subscribe(data: {})
      end
      it { expect(subscription).to be_rejected }

      it {
        expect(transmissions.last).to eq('No params specified.')
      }
    end
  end
end
