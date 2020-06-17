# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward
  belongs_to :requester, class_name: 'User'
end
