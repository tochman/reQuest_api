# frozen_string_literal: true

class Request::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :requester, :offerable, :reward, :category

  def requester
    object.requester.uid
  end

  def offerable
    return nil unless current_user
    return false if object.requester == current_user

    current_user_offers = object.offers.find_all { |offer| offer.helper_id == current_user.id }
    current_user_offers.empty? ? true : false
  end
end
