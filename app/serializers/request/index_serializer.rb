class Request::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :requester, :offerable

  def requester
    object.requester.uid
  end

  def offerable
    object.offerable
  end
end
