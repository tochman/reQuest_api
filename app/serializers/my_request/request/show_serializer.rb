# frozen_string_literal: true

class MyRequest::Request::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :reward, :offers, :status

  def offers
    offers_response = []
    object.offers.each do |offer|
      helper = User.find(offer.helper_id)
      offers_response << { email: helper.email, id: offer.id, message: offer.message, status: offer.status }
    end

    offers_response
  end
end
