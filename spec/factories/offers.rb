FactoryBot.define do
  factory :offer do
    association :helper, factory: :user
    association :request
    status { 'pending' }
  end
end
