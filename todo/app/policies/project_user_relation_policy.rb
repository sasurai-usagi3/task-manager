class ProjectUserRelationPolicy < ApplicationPolicy
  include ProjectSystem

  def initialize(user, project_user_relation)
    @user = user
    @project_user_relation = project_user_relation
    @group = project_user_relation.project.group
    @project = project_user_relation.project
  end

  def new?
    project_administrator?
  end

  def create?
    project_administrator? && @group.group_user_relations.exists?(user_id: @project_user_relation.user_id)
  end

  def edit?
    project_administrator? && @group.group_user_relations.exists?(user_id: @project_user_relation.user_id)
  end

  def update?
    project_administrator? && @group.group_user_relations.exists?(user_id: @project_user_relation.user_id)
  end

  def destroy?
    project_administrator?
  end
end
