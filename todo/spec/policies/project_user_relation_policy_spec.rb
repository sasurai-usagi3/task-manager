require 'rails_helper'

RSpec.describe ProjectUserRelationPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:administrator) { create(:user) }
  let(:general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:insider) { create(:user) }
  let(:outsider) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:project_user_relation_group_user) { project.project_user_relations.new(user: insider) }
  let(:project_user_relation_other) { project.project_user_relations.new(user: outsider) }

  before do
    project.project_user_relations.create!([{user: administrator, authority: 'administrator'}, {user: general_user, authority: 'general'}])
    project.group.group_user_relations.create!(user: insider, authority: 'general')
  end

  permissions :new?, :create?, :edit?, :update? do
    it { is_expected.to permit(administrator, project_user_relation_group_user) }
    it { is_expected.not_to permit(general_user, project_user_relation_group_user) }
    it { is_expected.not_to permit(other, project_user_relation_group_user) }
    it { is_expected.not_to permit(administrator, project_user_relation_other) }
    it { is_expected.not_to permit(general_user, project_user_relation_other) }
    it { is_expected.not_to permit(other, project_user_relation_other) }
  end

  permissions :destroy? do
    it { is_expected.to permit(administrator, project_user_relation_group_user) }
    it { is_expected.not_to permit(general_user, project_user_relation_group_user) }
    it { is_expected.not_to permit(other, project_user_relation_group_user) }
  end
end
