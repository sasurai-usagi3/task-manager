require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  subject { response }

  let(:group) { project.group }
  let(:project) { create(:project) }
  let(:project2) { create(:project) }
  let(:user) { create(:user) }

  context '非ログイン時' do
    shared_examples_for 'redirect to sign in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe '#index' do
      before { get :index, params: {group_id: group.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#new' do
      before { get :new, params: {group_id: group.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#create' do
      before { post :create, params: {group_id: group.id, project: project.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#edit' do
      before { get :edit, params: {id: project.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#update' do
      before { patch :update, params: {id: project.id, project: project2.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#destroy' do
      before { delete :destroy, params: {id: project.id} }

      it_behaves_like 'redirect to sign in'
    end
  end

  context '権限不足' do
    before { sign_in user }

    describe '#index' do
      it { expect { get :index, params: {group_id: group.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#new' do
      it { expect { get :new, params: {group_id: group.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#create' do
      it { expect { post :create, params: {group_id: group.id, project: project.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#edit' do
      it { expect { get :edit, params: {id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#update' do
      it { expect { patch :update, params: {id: project.id, project: project2.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#destroy' do
      it { expect { delete :destroy, params: {id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end
  end

  context '権限を持っている時' do
    before do
      sign_in user
      GroupUserRelation.create!(user: user, group: group, authority: 'owner')
    end

    describe '#index' do
      before { get :index, params: {group_id: group.id} }

      it { is_expected.to have_http_status 200 }
    end

    describe '#new' do
      before { get :new, params: {group_id: group.id} }

      it { is_expected.to have_http_status 200 }
    end

    describe '#create' do
      describe 'Redirect and so on' do
        before { post :create, params: {group_id: group.id, project: project.attributes} }

        it { is_expected.to redirect_to [group, :projects] }

        it '作成者が管理者になっていること' do
          project_user_relation = ProjectUserRelation.last

          expect(project_user_relation.user_id).to eq user.id
          expect(project_user_relation.administrator?).to be_truthy
        end
      end

      describe 'Create a record' do
        let(:project) { build(:project) }

        it { expect { post :create, params: {group_id: group.id, project: project.attributes} }.to change(Project, :count).by(1) }
        it { expect { post :create, params: {group_id: group.id, project: project.attributes} }.to change(ProjectUserRelation, :count).by(1) }
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

      let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('creator_id') }.tap { |attrs| attrs.delete('group_id') } } }

      it { is_expected.to redirect_to project }
      it { expect(remove_meta.call(Project.find(project.id).attributes)).to eq remove_meta.call(project2.attributes) }
    end

    describe '#destroy' do
      before { project.project_user_relations.create!(user: user, authority: 'administrator') }

      describe 'Redirect and destroy the record' do
        before { delete :destroy, params: {id: project.id} }

        it { is_expected.to redirect_to [group, :projects] }
        it { expect(Project.find_by(id: project.id)).to be_nil }
      end

      describe 'Destroy a record' do
        before { project }

        it { expect { delete :destroy, params: {id: project.id} }.to change(Project, :count).by(-1) }
      end
    end
  end
end
