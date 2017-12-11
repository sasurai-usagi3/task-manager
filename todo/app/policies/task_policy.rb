class TaskPolicy < ApplicationPolicy
  def initialize(user, task)
    @user = user
    @project = task.project
  end

  def show?
    member?
  end

  def new?
    member?
  end

  def create?
    member?
  end

  def edit?
    member?
  end

  def update?
    member?
  end

  def destroy?
    member?
  end
end
