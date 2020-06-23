# frozen_string_literal: true

class MyRequest::Quest::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :reward, :status, :requester

  def requester
    object.requester.email
  end
end
