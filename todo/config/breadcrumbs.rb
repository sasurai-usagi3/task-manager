crumb :root do
  link 'トップ', projects_path
end

crumb :projects_path do
  link 'プロジェクト一覧', projects_path
  parent :root
end

crumb :new_project_path do
  link'プロジェクト新規作成', new_project_path
  parent :projects_path
end

crumb :edit_project_path do |project|
  link'プロジェクト編集', [:edit, project]
  parent :projects_path
end

crumb :project_tasks_path do |project|
  link "プロジェクト「#{project.name}」タスク一覧", [project, :tasks]
  parent :projects_path
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
