FactoryBot.define do
  factory :quest do
    title { 'I need  help with this' }
    description { 'This is what I need help with' }
    association :requester, factory: :user
  end
end
