require 'rails_helper'

RSpec.describe ProjectUserRelationsController, type: :controller do
  subject { response }

  before do
    sign_in user
    project.project_user_relations.create!(user: user, authority: 'administrator')
  end

  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:project_user_relation) { ProjectUserRelation.create!(user: user2, project: project) }

  describe '#index' do
    before { get :index, params: {project_id: project.id} }

    it { is_expected.to have_http_status 200 }
  end

  describe '#new' do
    before { get :new, params: {project_id: project.id} }

    it { is_expected.to have_http_status 200 }
  end

  describe '#create' do
    describe 'Redirect and so on' do
      before { post :create, params: {project_id: project.id, project_user_relation: {user_id: user2.id}} }

      it { is_expected.to redirect_to [project, :project_user_relations] }
    end

    describe 'Create a record' do
      it { expect { post :create, params: {project_id: project.id, project_user_relation: {user_id: user2.id}} }.to change(ProjectUserRelation, :count).by(1) }
    end
  end

  describe '#edit' do
    before { get :edit, params: {project_id: project.id, id: project_user_relation.id} }

    it { is_expected.to have_http_status 200 }
    it { expect(assigns(:project_user_relation).id).to eq project_user_relation.id }
  end

  describe '#update' do
    before { patch :update, params: {project_id: project.id, id: project_user_relation.id, project_user_relation: {authority: 'administrator'}} }

    it { is_expected.to redirect_to [project, :project_user_relations] }
    it { expect(ProjectUserRelation.find(project_user_relation.id).authority).to eq 'administrator' }
  end

  describe '#destroy' do
    describe 'Redirect and destroy the record' do
      before { delete :destroy, params: {project_id: project.id, id: project_user_relation.id} }

      it { is_expected.to redirect_to [project, :project_user_relations] }
      it { expect(ProjectUserRelation.find_by(id: project_user_relation.id)).to be_nil }
    end

    describe 'Destroy a record' do
      before { project_user_relation }

      it { expect { delete :destroy, params: {id: project_user_relation.id} }.to change(ProjectUserRelation, :count).by(-1) }
    end
  end
end
