class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'
  validates_presence_of :content
  before_create :validate_user_is_authorized

  private

  def validate_user_is_authorized
    is_valid_user = sender == conversation.offer.helper || sender == conversation.offer.request.requester
    raise StandardError, 'You are not authorized to do this!' unless is_valid_user
  end
end
