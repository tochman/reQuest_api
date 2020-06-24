FactoryBot.define do
  factory :message do
    conversation
    content { "MyText" }
    user
  end
end
