require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Association' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'Enum' do
    it { should define_enum_for(:status).with(not_start: 0, in_progress: 1, done: 2) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:priority).only_integer.is_greater_than_or_equal_to(0).is_less_than(100) }
    it { should validate_presence_of(:status) }
  end
end
