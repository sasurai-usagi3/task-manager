crumb :root do
  link 'トップ', '/'
end

crumb :new_group_path do |group|
  link 'グループ作成一覧', [:new, :group]
  parent :root
end

crumb :edit_group_path do |group|
  link "グループ「#{group.name}」編集", [:edit, group]
  parent :root
end

crumb :group_projects_path do |group|
  link "グループ「#{group.name}」プロジェクト一覧", [group, :projects]
  parent :root
end

crumb :group_group_user_relations_path do |group|
  link "グループ「#{group.name}」メンバ一覧", [group, :group_user_relations]
  parent :group_projects_path, group
end

crumb :new_group_group_user_relation_path do |group|
  link "グループ「#{group.name}」メンバ追加", [group, :group_user_relations]
  parent :group_projects_path, group
end

crumb :edit_group_group_user_relation_path do |group_user_relation|
  group = group_user_relation.group
  link "グループ「#{group.name}」メンバ追加", [group, :group_user_relations]
  parent :group_projects_path, group
end

crumb :new_group_project_path do |group|
  link "グループ「#{group.name}」プロジェクト新規作成", [:new, group, :project]
  parent :group_projects_path, group
end

crumb :edit_project_path do |project|
  link 'プロジェクト編集', [:edit, project]
  parent :group_projects_path, project.group
end

crumb :project_tasks_path do |project|
  link "プロジェクト「#{project.name}」タスク一覧", [project, :tasks]
  parent :group_projects_path, project.group
end

crumb :project_project_user_relations_path do |project|
  link "プロジェクト「#{project.name}」メンバ一覧", [project, :project_user_relations]
  parent :project_tasks_path, project
end

crumb :new_project_project_user_relation_path do |project|
  link "プロジェクト「#{project.name}」メンバ追加", [project, :project_user_relations]
  parent :project_project_user_relations_path, project
end

crumb :edit_project_project_user_relation_path do |project_user_relation|
  project = project_user_relation.project
  link "プロジェクト「#{project.name}」メンバ編集", [project, :project_user_relations]
  parent :project_project_user_relations_path, project
end

crumb :project_user_works_path do |project, user|
  link "「#{user.nickname}」作業一覧", [project, user, :works]
  parent :project_project_user_relations_path, project
end

crumb :task_path do |task|
  link "タスク「#{task.title}」", task
  parent :project_tasks_path, task.project
end

crumb :new_project_task_path do |project|
  link "プロジェクト「#{project.name}」タスク新規作成", new_project_task_path
  parent :project_tasks_path, project
end

crumb :edit_task_path do |task|
  link "タスク「#{task.title}」編集", task
  parent :project_tasks_path, task.project
end
