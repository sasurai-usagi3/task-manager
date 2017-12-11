require 'rails_helper'

RSpec.describe TaskPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:administrator) { create(:user) }
  let(:general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:task) { create(:task, project: project, user: creator) }

  before { project.project_user_relations.create!([{user: administrator, authority: 'administrator'}, {user: general_user, authority: 'general'}]) }

  permissions :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.to permit(administrator, task) }
    it { is_expected.to permit(general_user, task) }
    it { is_expected.not_to permit(other, task) }
  end
end
