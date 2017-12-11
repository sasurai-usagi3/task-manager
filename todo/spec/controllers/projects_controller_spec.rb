require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  subject { response }

  before { sign_in user }

  let(:project) { create(:project) }
  let(:user) { create(:user) }

  describe '#index' do
    before { get :index }

    it { is_expected.to have_http_status 200 }
  end

  describe '#new' do
    before { get :new }

    it { is_expected.to have_http_status 200 }
  end

  describe '#create' do
    describe 'Redirect and so on' do
      before { post :create, params: {project: project.attributes} }

      it { is_expected.to redirect_to projects_path }

      it '作成者が管理者になっていること' do
        project_user_relation = ProjectUserRelation.last

        expect(project_user_relation.user_id).to eq user.id
        expect(project_user_relation.administrator?).to be_truthy
      end
    end

    describe 'Create a record' do
      let(:project) { build(:project) }

      it { expect { post :create, params: {project: project.attributes} }.to change(Project, :count).by(1) }
      it { expect { post :create, params: {project: project.attributes} }.to change(ProjectUserRelation, :count).by(1) }
    end
  end

  describe '#edit' do
    before { project.project_user_relations.create!(user: user, authority: 'administrator') }
    before { get :edit, params: {id: project.id} }

    it { is_expected.to have_http_status 200 }
    it { expect(assigns(:project).id).to eq project.id }
  end

  describe '#update' do
    before { project.project_user_relations.create!(user: user, authority: 'administrator') }
    before { patch :update, params: {id: project.id, project: project2.attributes} }

    let(:project2) { create(:project) }
    let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('creator_id') } } }

    it { is_expected.to redirect_to project }
    it { expect(remove_meta.call(Project.find(project.id).attributes)).to eq remove_meta.call(project2.attributes) }
  end

  describe '#destroy' do
    before { project.project_user_relations.create!(user: user, authority: 'administrator') }

    describe 'Redirect and destroy the record' do
      before { delete :destroy, params: {id: project.id} }

      it { is_expected.to redirect_to projects_path }
      it { expect(Project.find_by(id: project.id)).to be_nil }
    end

    describe 'Destroy a record' do
      before { project }

      it { expect { delete :destroy, params: {id: project.id} }.to change(Project, :count).by(-1) }
    end
  end
end
