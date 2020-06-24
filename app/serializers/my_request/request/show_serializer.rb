# frozen_string_literal: true

class MyRequest::Request::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :reward, :status, :offers

  def offers
    offers_response = []
    object.offers.each do |offer|
      helper = User.find(offer.helper_id)
      offers_response << {
        id: offer.id,
        email: helper.email,
        status: offer.status,
        conversation: {
          messages:
          offer.conversation.messages.map do |message|
            { content: message.content, me: message.sender == current_user }
          end
        }
      }
    end

    offers_response
  end
end
