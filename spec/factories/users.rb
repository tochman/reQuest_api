FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "MyString123" }
  end
end
