require 'rails_helper'

RSpec.describe ProjectUserRelationsController, type: :controller do
  subject { response }

  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:project_user_relation) { ProjectUserRelation.create!(user: user2, project: project) }

  context '非ログイン時' do
    shared_examples_for 'redirect to sign in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe '#index' do
      before { get :index, params: {project_id: project.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#new' do
      before { get :new, params: {project_id: project.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#create' do
      before { post :create, params: {project_id: project.id, project_user_relation: {user_id: user2.id}} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#edit' do
      before { get :edit, params: {project_id: project.id, id: project_user_relation.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#update' do
      before { patch :update, params: {project_id: project.id, id: project_user_relation.id, project_user_relation: {authority: 'administrator'}} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#destroy' do
      before { delete :destroy, params: {project_id: project.id, id: project_user_relation.id} }

      it_behaves_like 'redirect to sign in'
    end
  end

  context '権限不足' do
    before do
      sign_in user
    end

    describe '#index' do
      it { expect { get :index, params: {project_id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#new' do
      it { expect { get :new, params: {project_id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#create' do
      it { expect { post :create, params: {project_id: project.id, project_user_relation: {user_id: user2.id}} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#edit' do
      it { expect { get :edit, params: {project_id: project.id, id: project_user_relation.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#update' do
      it { expect { patch :update, params: {project_id: project.id, id: project_user_relation.id, project_user_relation: {authority: 'administrator'}} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#destroy' do
      it { expect { delete :destroy, params: {project_id: project.id, id: project_user_relation.id} }.to raise_error Pundit::NotAuthorizedError }
    end
  end

  context '権限あり' do
    before do
      sign_in user
      GroupUserRelation.create!(user: user2, group: project.group)
      project.project_user_relations.create!(user: user, authority: 'administrator')
    end

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
end
