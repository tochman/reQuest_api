# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "MyString123" }
    karma_points { 100 }
  end
end
