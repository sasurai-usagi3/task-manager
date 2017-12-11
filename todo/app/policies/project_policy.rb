class ProjectPolicy < ApplicationPolicy
  def initialize(user, project)
    @user = user
    @project = project
  end

  def show?
    member?
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
