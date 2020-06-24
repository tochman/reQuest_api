FactoryBot.define do
  factory :message do
    conversation
    content { "MyText" }
    association :sender, factory: :user
  end
end
