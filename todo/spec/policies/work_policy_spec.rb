require 'rails_helper'

RSpec.describe WorkPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:project_administrator) { create(:user) }
  let(:project_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:task) { create(:task, project: project, user: creator) }
  let(:work) { create(:work, project: project, task: task, user: creator) }

  before { project.project_user_relations.create!([{user: creator, authority: 'administrator'}, {user: project_administrator, authority: 'administrator'}, {user: project_user, authority: 'general'}]) }

  permissions :create? do
    it { is_expected.to permit(creator, work) }
    it { is_expected.to permit(project_administrator, work) }
    it { is_expected.to permit(project_user, work) }
    it { is_expected.not_to permit(other, work) }
  end

  permissions :edit?, :update?, :destroy? do
    it { is_expected.to permit(creator, work) }
    it { is_expected.to permit(project_administrator, work) }
    it { is_expected.not_to permit(project_user, work) }
    it { is_expected.not_to permit(other, work) }
  end
end
