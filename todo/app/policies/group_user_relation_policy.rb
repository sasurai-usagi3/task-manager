class GroupUserRelationPolicy < ApplicationPolicy
  include GroupSystem

  def initialize(user, group_user_relation)
    @user = user
    @group = group_user_relation.group
  end

  def new?
    group_administrator?
  end

  def create?
    group_administrator?
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
