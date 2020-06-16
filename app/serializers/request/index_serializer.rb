class Request::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :requester

  def requester
    object.requester.uid
  end
end
