# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfferConversationChannel, type: :channel do
  let(:user) { create(:user) }
  describe 'subscription' do
    before { stub_connection current_user: user }
    describe 'valid parameters' do
      before do
        subscribe(data: { offer_id: 234 })
      end

      it {
        expect(subscription).to be_confirmed
      }

      it {
        expect(subscription).to have_stream_from("offer_conversation_234")
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
