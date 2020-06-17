# frozen_string_literal: true

class Request::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :requester, :reward

  def requester
    object.requester.uid
  end
end
