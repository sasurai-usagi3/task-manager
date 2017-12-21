FactoryBot.define do
  factory :work do
    project { create(:project) }
    task { create(:task) }
    user { create(:user) }
    sequence(:title) { |n| "タイトル#{n}" }
    description '説明'
    amount 10
  end
end
