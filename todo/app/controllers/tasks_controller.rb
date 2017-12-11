class TasksController < ApplicationController
  before_action :find_project, except: [:show, :edit, :update, :destroy]
  before_action :find_task, except: :index

  def index
    authorize @project, :show?

    @q_tasks = @project.tasks.ransack(params[:q])
    @tasks = @q_tasks.result(distinct: true).order(priority: :desc).page(params[:page]).per(10)
  end

  def show
    authorize @task
  end

  def new
    authorize @task
  end

  def create
    authorize @task

    if @task.save
      redirect_to [@project, :tasks]
    else
      render 'new'
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task

    if @task.update(task_params)
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    authorize @task

    @task.destroy

    redirect_to [@task.project, :tasks]
  end

private
  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_task
    @task = Task.find_by(id: params[:id]) || @project.tasks.new(task_params.merge(user: current_user, status: 'not_start'))
  end

  def task_params
    params.fetch(:task, {}).permit(:title, :priority, :status)
  end
end