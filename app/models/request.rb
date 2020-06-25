# frozen_string_literal: true

class Request < ApplicationRecord
  validates_presence_of :title, :description, :reward, :status, :category
  belongs_to :requester, class_name: 'User'
  belongs_to :helper, required: false, class_name: 'User'
  has_many :offers
  enum status: { pending: 0, active: 1, started: 2, completed: 3 }
  enum category: { other: 0, education: 1, home: 2, it: 3, sport: 4, vehicles: 5 }
  validate :validate_pending_status, on: :update
  validates_numericality_of :reward, greater_than_or_equal_to: 0
  validates_numericality_of :lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90
  validates_numericality_of :long, greater_than_or_equal_to: -180, less_than_or_equal_to: 180
  after_update :reward_helper

  def requested_by?(user)
    requester == user
  end

  def validate_requester(user)
    message = 'This is not your reQuest'
    raise StandardError, message unless requested_by? user

    true
  end

  def update_when_offer_accepted(helper)
    update(status: 'active', helper: helper)
  end

  def reward_helper
    helper.reward_karma_points(reward) if completed?
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
