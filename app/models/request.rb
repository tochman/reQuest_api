# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward, :status
  belongs_to :requester, class_name: 'User'
  has_many :offers
  enum status: %i[pending active completed]
end
