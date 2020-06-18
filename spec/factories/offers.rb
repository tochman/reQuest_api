FactoryBot.define do
  factory :offer do
    message { "I want to help" }
    association :helper, factory: :user, email: "helper@mail.com"
    association :request
  end
end
