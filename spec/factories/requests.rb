# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    title { 'I need  help with this' }
    description { 'This is what I need help with' }
    reward { 100 }
    status { 'pending' }
    category { 'education' }
    association :requester, factory: :user
  end
end
