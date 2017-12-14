class GroupsController < ApplicationController
  before_action :find_group

  def new
  end

  def create
    if @group.save
      @group.group_user_relations.create!(user: current_user, authority: 'owner')
      redirect_to [@group, :projects]
    else
      render 'new', status: :bad_request
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group

    if @group.update(group_params)
      redirect_to [@group, :projects]
    else
      render 'edit', status: :bad_request
    end
  end

  def destroy
    authorize @group

    @group.destroy

    redirect_to '/'
  end

private
  def find_group
    @group = Group.find_by(id: params[:id]) || Group.new(group_params.merge(creator: current_user))
  end

  def group_params
    params.fetch(:group, {}).permit(:name, :description)
  end
end
