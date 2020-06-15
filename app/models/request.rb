class Request < ApplicationRecord
  validates_presence_of :title, :description
  belongs_to :requester, class_name: 'User'
end
