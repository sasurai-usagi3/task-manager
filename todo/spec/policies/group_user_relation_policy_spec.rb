require 'rails_helper'

RSpec.describe GroupUserRelationPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:group_owner) { create(:user) }
  let(:group_administrator) { create(:user) }
  let(:group_general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:group) { create(:group) }
  let(:group_user_relation) { group.group_user_relations.create!(user: create(:user), authority: 'owner') }

  before { group.group_user_relations.create!([{user: group_owner, authority: 'owner'}, {user: group_administrator, authority: 'administrator'}, {user: group_general_user, authority: 'general'}]) }

  permissions :new?, :create?, :edit?, :update? do
    it { is_expected.to permit(group_owner, group_user_relation) }
    it { is_expected.to permit(group_administrator, group_user_relation) }
    it { is_expected.not_to permit(group_general_user, group_user_relation) }
    it { is_expected.not_to permit(other, group_user_relation) }
  end

  permissions :destroy? do
    it { is_expected.to permit(group_owner, group_user_relation) }
    it { is_expected.not_to permit(group_administrator, group_user_relation) }
    it { is_expected.not_to permit(group_general_user, group_user_relation) }
    it { is_expected.not_to permit(other, group_user_relation) }
  end
end
