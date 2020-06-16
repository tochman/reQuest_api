class Offer < ApplicationRecord
  belongs_to :request
  belongs_to :helper, class_name: 'User'
end
