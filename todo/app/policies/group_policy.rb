class GroupPolicy < ApplicationPolicy
  include GroupSystem

  def initialize(user, group)
    @user = user
    @group = group
  end

  def show?
    group_member?
  end

  def edit?
    group_administrator?
  end

  def update?
    group_administrator?
  end

  def destroy?
    group_owner?
  end
end
