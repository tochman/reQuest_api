class Conversation < ApplicationRecord
  belongs_to :offer
  has_many :messages
end
