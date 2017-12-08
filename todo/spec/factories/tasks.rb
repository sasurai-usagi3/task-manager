FactoryBot.define do
  factory :task do
    project { create(:project) }
    user { create(:user) }
    sequence(:title) { |n| "タスク#{n}" }
    description '説明'
    priority 0
    status 0
  end
end
