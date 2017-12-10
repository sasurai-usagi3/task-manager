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

private
  def administrator?
    @project.project_user_relations.exists?(user_id: @user, authority: 'administrator')
  end

  def member?
    @project.project_user_relations.exists?(user_id: @user)
  end
end
