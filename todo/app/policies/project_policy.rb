class ProjectPolicy < ApplicationPolicy
  include GroupSystem
  include ProjectSystem

  def initialize(user, project)
    @user = user
    @project = project
    @group = project.group
  end

  def show?
    project_member?
  end

  def new?
    group_administrator?
  end

  def create?
    group_administrator?
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
