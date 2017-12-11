module GroupSystem
  def group_member?
    @group.group_user_relations.exists?(user_id: @user)
  end

  def group_administrator?
    @group.group_user_relations.exists?(user_id: @user, authority: 'administrator') || @group.group_user_relations.exists?(user_id: @user, authority: 'owner')
  end

  def group_owner?
    @group.group_user_relations.exists?(user_id: @user, authority: 'owner')
  end
end
