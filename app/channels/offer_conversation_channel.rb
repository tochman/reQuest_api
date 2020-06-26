class OfferConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from offer_identifier
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def offer_identifier
    identifier = params[:data][:offer_id]
    "offer_conversation_#{identifier}"
  end
end
