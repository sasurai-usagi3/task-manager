require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    it { should have_many(:group_user_relations).dependent(:destroy) }
    it { should have_many(:joined_groups).through(:group_user_relations).source(:group) }
    it { should have_many(:project_user_relations).dependent(:destroy) }
    it { should have_many(:joined_projects).through(:project_user_relations).source(:project) }
    it { should have_many(:launched_projects).class_name('Project').with_foreign_key('creator_id').dependent(:destroy) }
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:works).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:nickname) }
  end
end
