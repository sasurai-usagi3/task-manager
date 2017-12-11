FactoryBot.define do
  factory :project do
    group { create(:group) }
    creator { create(:user) }
    sequence(:name) { |n| "プロジェクト#{n}" }
    description 'プロジェクトの説明'
  end
end
