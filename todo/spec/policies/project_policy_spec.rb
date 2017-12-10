require 'rails_helper'

RSpec.describe ProjectPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:administrator) { create(:user) }
  let(:general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }

  before { project.project_user_relations.create!([{user: administrator, authority: 'administrator'}, {user: general_user, authority: 'general'}]) }

  permissions :show? do
    it { is_expected.to permit(administrator, project) }
    it { is_expected.to permit(general_user, project) }
    it { is_expected.not_to permit(other, project) }
  end

  permissions :edit?, :update?, :destroy? do
    it { is_expected.to permit(administrator, project) }
    it { is_expected.not_to permit(general_user, project) }
    it { is_expected.not_to permit(other, project) }
  end
end
