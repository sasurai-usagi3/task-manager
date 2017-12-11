class ProjectUserRelationPolicy < ApplicationPolicy
  def initialize(user, project_user_relation)
    @user = user
    @project = project_user_relation.project
  end

  def new?
    administrator?
  end

  def create?
    administrator?
  end

  def edit?
    administrator?
  end

  def update?
    administrator?
  end

  def destroy?
    administrator?
  end
end
