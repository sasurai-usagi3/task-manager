require 'rails_helper'

RSpec.describe GroupPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:group_owner) { create(:user) }
  let(:group_administrator) { create(:user) }
  let(:group_general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:group) { project.group }

  before { group.group_user_relations.create!([{user: group_owner, authority: 'owner'}, {user: group_administrator, authority: 'administrator'}, {user: group_general_user, authority: 'general'}]) }

  permissions :show? do
    it { is_expected.to permit(group_owner, group) }
    it { is_expected.to permit(group_administrator, group) }
    it { is_expected.to permit(group_general_user, group) }
    it { is_expected.not_to permit(other, group) }
  end

  permissions :edit?, :update? do
    it { is_expected.to permit(group_owner, group) }
    it { is_expected.to permit(group_administrator, group) }
    it { is_expected.not_to permit(group_general_user, group) }
    it { is_expected.not_to permit(other, group) }
  end

  permissions :destroy? do
    it { is_expected.to permit(group_owner, group) }
    it { is_expected.not_to permit(group_administrator, group) }
    it { is_expected.not_to permit(group_general_user, group) }
    it { is_expected.not_to permit(other, group) }
  end
end
