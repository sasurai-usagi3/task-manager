FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "プロジェクト#{n}" }
    description 'プロジェクトの説明'
  end
end
