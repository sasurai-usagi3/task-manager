class ProjectsController < ApplicationController
  before_action :find_project, except: :index
  def index
    @projects = Project.page(params[:page]).per(10)
  end

  def show
    authorize @project

    render status: :not_found if @project.nil?
  end

  def new
  end

  def create
    if @project.save
      @project.project_user_relations.create!(user: current_user, authority: 'administrator')

      redirect_to projects_path
    else
      render 'new'
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
      render 'edit'
    end
  end

  def destroy
    authorize @project

    @project.destroy

    redirect_to projects_path
  end

private
  def find_project
    @project = Project.find_by(id: params[:id]) || Project.new(project_params.merge(creator: current_user))
  end

  def project_params
    params.fetch(:project, {}).permit(:name, :description)
  end
end
