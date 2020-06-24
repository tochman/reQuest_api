# frozen_string_literal: true

class Offer < ApplicationRecord
  before_save :validate_offer_creator
  validates_presence_of :status
  belongs_to :request
  belongs_to :helper, class_name: 'User'
  has_one :conversation
  validates_uniqueness_of :helper_id, scope: :request_id, message: 'is already registered with this request'
  enum status: %i[pending accepted declined]
  before_update :update_request_status
  after_create :attach_conversation

  def append_message(message)
    conversation.messages.create(content: message, sender: helper)
  end

  private

  def validate_offer_creator
    if request.requested_by?(helper)
      raise StandardError, 'You cannot offer help on your own request!'
    end
  end

  def update_request_status
    if accepted? && status_was == 'pending'
      request.update_when_offer_accepted(helper)
    end
  end

  def attach_conversation
    Conversation.create(offer_id: id)
  end
end
