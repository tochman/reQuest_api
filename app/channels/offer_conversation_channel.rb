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
    if params[:room][:offer_id]
      channel = "offer_conversation_#{params[:room][:offer_id]}"
    else
      connection.transmit identifier: params, message: 'No params specified.'
      reject && return
    end
    channel
  end
end
