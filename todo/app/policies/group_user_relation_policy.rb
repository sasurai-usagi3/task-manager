class GroupUserRelationPolicy < ApplicationPolicy
  include GroupSystem

  def initialize(user, group_user_relation)
    @user = user
    @group_user_relation = group_user_relation
    @group = group_user_relation.group
  end

  def new?
    group_owner? || (group_administrator? && !@group_user_relation.owner?)
  end

  def create?
    group_owner? || (group_administrator? && !@group_user_relation.owner?)
  end

  def edit?
    group_owner? || (group_administrator? && !@group_user_relation.owner?)
  end

  def update?
    group_owner? || (group_administrator? && !@group_user_relation.owner?)
  end

  def destroy?
    group_owner?
  end
end
