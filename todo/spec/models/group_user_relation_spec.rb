require 'rails_helper'

RSpec.describe GroupUserRelation, type: :model do
  describe 'Association' do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
  end

  describe 'Enum' do
    it { should define_enum_for(:authority).with(general: 0, owner: 1, administrator: 2) }
  end

  describe 'Association' do
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:authority) }
  end
end
