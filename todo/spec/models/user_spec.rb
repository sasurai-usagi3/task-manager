require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    it { should have_many(:launched_projects).class_name('Project').with_foreign_key('creator_id').dependent(:destroy) }
    it { should have_many(:projects).through(:project_user_relations) }
    it { should have_many(:project_user_relations).dependent(:destroy) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:nickname) }
  end
end
