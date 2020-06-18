# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward, :status
  belongs_to :requester, class_name: 'User'
  has_many :offers
  enum status: { pending: 0, active: 1, started: 2, completed: 3 }
  validate :validate_pending_status, on: :update

  def is_requested_by?(user)
    #binding.pry
    raise StandardError.new "Request not reachable" and return false unless requester == user
    true
  end

  private

  def validate_pending_status
    if status_was == 'pending' && status_changed? && completed?
      errors.add(
        :status,
        :restricted,
        message: 'cannot be set to completed when it is pending'
      )
      restore_status!
    end
  end
end
