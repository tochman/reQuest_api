FactoryBot.define do
  factory :message do
    conversation
    content { "MyText" }
    sender { conversation.offer.helper }
  end
end
