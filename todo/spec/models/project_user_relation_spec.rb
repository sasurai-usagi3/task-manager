require 'rails_helper'

RSpec.describe ProjectUserRelation, type: :model do
  describe 'Association' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'Enum' do
    it { should define_enum_for(:authority).with(general: 0, administrator: 1) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:authority) }
  end
end
