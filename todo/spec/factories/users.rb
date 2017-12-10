FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:nickname) { |n| "ユーザ#{n}" }
    password 'password'
  end
end
