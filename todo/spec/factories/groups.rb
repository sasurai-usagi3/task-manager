FactoryBot.define do
  factory :group do
    creator { create(:user) }
    sequence(:name) { |n| "グループ#{n}" }
    description 'MyText'
  end
end
