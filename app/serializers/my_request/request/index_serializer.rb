# frozen_string_literal: true

class MyRequest::Request::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :reward, :status
end
