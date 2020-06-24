class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :conversation
  has_one :user
end
