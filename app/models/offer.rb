# frozen_string_literal: true

class Offer < ApplicationRecord
  before_validation :validate_offer, on: [:create]
  validates_presence_of :status
  belongs_to :request
  belongs_to :helper, class_name: 'User'
  validates_uniqueness_of :helper_id, scope: :request_id, message: 'is already registered with this request'
  enum status: %i[pending accepted declined]
  around_update :update_request_status

  private

  def validate_offer
    if helper_id.present? && helper_id === request.requester.id
      raise StandardError, 'You cannot offer help on your own request!'
    end
  end

  def update_request_status
    if status == "accepted" && status_was == "pending"
      request.update_when_offer_accepted(helper)
    end
  end
end
