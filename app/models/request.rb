# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward, :status, :category
  belongs_to :requester, class_name: 'User'
  belongs_to :helper, required: false, class_name: 'User'
  has_many :offers
  enum status: { pending: 0, active: 1, started: 2, completed: 3 }
  enum category: { other: 0, education: 1, home: 2, it: 3, sport: 4, vehicles: 5 }
  validate :validate_pending_status, on: :update

  def is_requested_by?(user)
    raise(StandardError, 'This is not your reQuest') unless requester == user

    true
  end

  def update_when_offer_accepted(helper)
    update(status: 'active', helper: helper)
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
