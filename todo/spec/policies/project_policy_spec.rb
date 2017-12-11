require 'rails_helper'

RSpec.describe ProjectPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:group_owner) { create(:user) }
  let(:group_administrator) { create(:user) }
  let(:group_general_user) { create(:user) }
  let(:project_administrator) { create(:user) }
  let(:project_general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:group) { project.group }

  before do
    group.group_user_relations.create!([{user: group_owner, authority: 'owner'}, {user: group_administrator, authority: 'administrator'}, {user: group_general_user, authority: 'general'}])
    project.project_user_relations.create!([{user: project_administrator, authority: 'administrator'}, {user: project_general_user, authority: 'general'}])
  end

  permissions :new?, :create? do
    it { is_expected.to permit(group_owner, project) }
    it { is_expected.to permit(group_administrator, project) }
    it { is_expected.not_to permit(group_general_user, project) }
    it { is_expected.not_to permit(other, project) }
  end

  permissions :show? do
    it { is_expected.to permit(project_administrator, project) }
    it { is_expected.to permit(project_general_user, project) }
    it { is_expected.not_to permit(other, project) }
  end

  permissions :edit?, :update?, :destroy? do
    it { is_expected.to permit(project_administrator, project) }
    it { is_expected.not_to permit(project_general_user, project) }
    it { is_expected.not_to permit(other, project) }
  end
end
