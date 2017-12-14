module ProjectSystem
  def project_member?
    @project.project_user_relations.exists?(user_id: @user)
  end

  def project_administrator?
    @project.project_user_relations.exists?(user_id: @user, authority: 'administrator')
  end
end
