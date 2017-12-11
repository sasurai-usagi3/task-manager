class ProjectUserRelationPolicy < ApplicationPolicy
  include ProjectSystem

  def initialize(user, project_user_relation)
    @user = user
    @project = project_user_relation.project
  end

  def new?
    project_administrator?
  end

  def create?
    project_administrator?
  end

  def edit?
    project_administrator?
  end

  def update?
    project_administrator?
  end

  def destroy?
    project_administrator?
  end
end
