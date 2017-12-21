class WorksController < ApplicationController
  before_action :find_task, only: :create
  before_action :find_work, except: :index

  def index
    @project = Project.find(params[:project_id])
    @user = @project.users.find(params[:user_id])

    authorize @project, :show?

    @works = @project.works.includes(:user).where(user: @user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    authorize @work

    if @work.save
      @works = @task.works.order(created_at: :desc)

      render 'list', status: :created
    else
      head :bad_request
    end
  end

  def edit
    authorize @work
  end

  def update
    authorize @work

    @work.assign_attributes(work_params)

    if @work.save
      @works = @work.task.works.order(created_at: :desc)

      render 'list', status: :accepted
    else
      head :bad_request
    end
  end

  def destroy
    authorize @work

    @work.destroy

    @works = @work.task.works.order(created_at: :desc)

    render 'list', status: :accepted
  end

private
  def find_task
    @task = Task.find(params[:task_id])
  end

  def find_work
    @work = Work.find_by(id: params[:id]) || @task.works.new(work_params.merge(user: current_user, project: @task.project))
  end

  def work_params
    params.fetch(:work, {}).permit(:title, :description, :amount)
  end
end
