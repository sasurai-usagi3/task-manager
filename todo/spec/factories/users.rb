FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "ユーザ#{n}" }
  end
end
