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
