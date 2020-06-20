# frozen_string_literal: true

class MyRequest::Quest::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :reward
end
