class WorkPolicy < ApplicationPolicy
  include ProjectSystem

  def initialize(user, work)
    @user = user
    @work = work
    @project = work.project
  end

  def create?
    project_member?
  end

  def edit?
    project_administrator? || @user.id == @work.user_id
  end

  def update?
    project_administrator? || @user.id == @work.user_id
  end

  def destroy?
    project_administrator? || @user.id == @work.user_id
  end
end
