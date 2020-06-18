# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward, :status
  belongs_to :requester, class_name: 'User'
  has_many :offers
  enum status: { pending: 0, active: 1, started: 2, completed: 3 }
end
