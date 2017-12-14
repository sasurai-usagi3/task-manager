class TaskPolicy < ApplicationPolicy
  include ProjectSystem

  def initialize(user, task)
    @user = user
    @project = task.project
  end

  def show?
    project_member?
  end

  def new?
    project_member?
  end

  def create?
    project_member?
  end

  def edit?
    project_member?
  end

  def update?
    project_member?
  end

  def destroy?
    project_member?
  end
end
