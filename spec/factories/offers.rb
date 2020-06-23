FactoryBot.define do
  factory :offer do
    message { 'I want  to help' }
    association :helper, factory: :user
    association :request
    status { 'pending' }
  end
end
