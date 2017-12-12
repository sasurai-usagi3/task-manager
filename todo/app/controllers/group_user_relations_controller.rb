class GroupUserRelationsController < ApplicationController
  before_action :find_group, except: [:edit, :update, :destroy]
  before_action :find_group_user_relation, except: :index

  def index
    authorize @group, :show?

    @group_user_relations = @group.group_user_relations.page(params[:page]).per(10)
  end

  def new
    authorize @group_user_relation
  end

  def create
    authorize @group_user_relation

    if @group_user_relation.save
      redirect_to [@group, :group_user_relations]
    else
      render 'new'
    end
  end

  def edit
    authorize @group_user_relation
  end

  def update
    @group_user_relation.assign_attributes(group_user_relation_params)

    authorize @group_user_relation

    if @group_user_relation.save
      redirect_to [@group_user_relation.group, :group_user_relations]
    else
      render 'edit'
    end
  end

  def destroy
    authorize @group_user_relation

    @group_user_relation.destroy

    redirect_to [@group_user_relation.group, :group_user_relations]
  end

private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_group_user_relation
    @group_user_relation = GroupUserRelation.find_by(id: params[:id]) || @group.group_user_relations.new(group_user_relation_params)
  end

  def group_user_relation_params
    params.fetch(:group_user_relation, {}).permit(:user_id, :authority)
  end
end
