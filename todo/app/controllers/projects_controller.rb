class ProjectsController < ApplicationController
  before_action :find_group, except: [:show, :edit, :update, :destroy]
  before_action :find_project, except: :index

  def index
    authorize @group, :show?

    @q_projects = current_user.joined_projects.where(group: @group).ransack(params[:q])
    @projects = @q_projects.result(distinct: true).order(id: :desc).page(params[:page]).per(10)
  end

  def new
    authorize @project
  end

  def create
    authorize @project

    if @project.save
      @project.project_user_relations.create!(user: current_user, authority: 'administrator')
      redirect_to [@group, :projects]
    else
      render 'new', status: :bad_request
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project
    else
      render 'edit', status: :bad_request
    end
  end

  def destroy
    authorize @project

    @project.destroy

    redirect_to [@project.group, :projects]
  end

private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_project
    @project = Project.find_by(id: params[:id]) || @group.projects.new(project_params.merge(creator: current_user))
  end

  def project_params
    params.fetch(:project, {}).permit(:name, :description)
  end
end
