class ProjectUserRelationsController < ApplicationController
  before_action :find_project, except: [:edit, :update, :destroy]
  before_action :find_project_user_relation

  def index
    authorize @project, :show?

    @project_user_relations = @project.project_user_relations.page(params[:page]).per(10)
  end

  def new
    authorize @project_user_relation
  end

  def create
    authorize @project_user_relation

    if @project_user_relation.save
      redirect_to [@project, :project_user_relations]
    else
      render 'new', status: :bad_request
    end
  end

  def edit
    authorize @project_user_relation
  end

  def update
    authorize @project_user_relation

    if @project_user_relation.update(project_user_relation_params)
      redirect_to [@project_user_relation.project, :project_user_relations]
    else
      render 'edit', status: :bad_request
    end
  end

  def destroy
    authorize @project_user_relation

    @project_user_relation.destroy

    redirect_to [@project_user_relation.project, :project_user_relations]
  end

private
  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_project_user_relation
    @project_user_relation = ProjectUserRelation.find_by(id: params[:id]) || @project&.project_user_relations&.new(project_user_relation_params)
  end

  def project_user_relation_params
    params.fetch(:project_user_relation, {}).permit(:user_id, :authority)
  end
end
