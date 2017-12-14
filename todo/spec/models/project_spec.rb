require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Association' do
    it { should belong_to(:creator).class_name('User') }
    it { should belong_to(:group) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:users).through(:project_user_relations) }
    it { should have_many(:project_user_relations).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:name) }
  end
end
