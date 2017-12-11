require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'Association' do
    it { should belong_to(:creator).class_name('User') }
    it { should have_many(:group_user_relations).dependent(:destroy) }
    it { should have_many(:members).through(:group_user_relations).source(:user) }
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:name) }
  end
end
