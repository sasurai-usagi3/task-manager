require 'rails_helper'

RSpec.describe ProjectUserRelationPolicy do
  subject { described_class }

  let(:creator) { create(:user) }
  let(:administrator) { create(:user) }
  let(:general_user) { create(:user) }
  let(:other) { create(:user) }
  let(:project) { create(:project, creator: creator) }
  let(:project_user_relation) { project.project_user_relations.new }

  before { project.project_user_relations.create!([{user: administrator, authority: 'administrator'}, {user: general_user, authority: 'general'}]) }

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.to permit(administrator, project_user_relation) }
    it { is_expected.not_to permit(general_user, project_user_relation) }
    it { is_expected.not_to permit(other, project_user_relation) }
  end
end
