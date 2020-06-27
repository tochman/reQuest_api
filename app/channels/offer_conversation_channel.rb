# frozen_string_literal: true

class OfferConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from offer_identifier
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def offer_identifier
    if params[:data][:offer_id]
      "offer_conversation_#{params[:data][:offer_id]}"
    else
      connection.transmit identifier: params, message: 'No params specified.'
      reject
    end
  end
end
