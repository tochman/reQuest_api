# frozen_string_literal: true

class MyRequest::Quest::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :email, :reward, :status, :offer

  def offer
    offer = object.offers.find{|offer| offer.helper == current_user}
    {
      id: offer.id,
      status: offer.status,
      conversation: {
        messages:
        offer.conversation.messages.map do |message|
          { content: message.content, me: message.sender == current_user }
        end
      }
    }
  end

  def email
    object.requester.email
  end
end
