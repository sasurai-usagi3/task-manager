require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  subject { response }

  let(:task) { create(:task) }
  let(:task2) { create(:task, priority: 10) }
  let(:project) { task.project }
  let(:user) { create(:user) }

  context '非ログイン時' do
    shared_examples_for 'redirect to sign in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe '#index' do
      before { get :index, params: {project_id: project.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#show' do
      before { get :show, params: {project_id: project.id, id: task.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#new' do
      before { get :new, params: {project_id: project.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#create' do
      before { post :create, params: {project_id: project.id, task: task.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#edit' do
      before { get :edit, params: {id: task.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#update' do
      before { patch :update, params: {id: task.id, project: task2.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#destroy' do
      before { delete :destroy, params: {id: task.id} }

      it_behaves_like 'redirect to sign in'
    end
  end

  context '非ログイン時' do
    before { sign_in user }

    describe '#index' do
      it { expect { get :index, params: {project_id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#show' do
      it { expect { get :show, params: {project_id: project.id, id: task.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#new' do
      it { expect { get :new, params: {project_id: project.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#create' do
      it { expect { post :create, params: {project_id: project.id, task: task.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#edit' do
      it { expect { get :edit, params: {id: task.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#update' do
      it { expect { patch :update, params: {id: task.id, project: task2.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#destroy' do
      it { expect { delete :destroy, params: {id: task.id} }.to raise_error Pundit::NotAuthorizedError }
    end
  end

  context '権限を持っている時' do
    before do
      sign_in user
      project.project_user_relations.create!(user: user, authority: 'administrator')
    end

    describe '#index' do
      before { get :index, params: {project_id: project.id} }

      it { is_expected.to have_http_status 200 }
    end

    describe '#show' do
      before { get :show, params: {project_id: project.id, id: task.id} }

      it { is_expected.to have_http_status 200 }
      it { expect(assigns(:task).id).to eq task.id }
    end

    describe '#new' do
      before { get :new, params: {project_id: project.id} }

      it { is_expected.to have_http_status 200 }
    end

    describe '#create' do
      describe 'Redirect and so on' do
        before { post :create, params: {project_id: project.id, task: task.attributes} }

        it { is_expected.to redirect_to [project, :tasks] }
      end

      describe 'Create a record' do
        let(:task) { build(:task) }

        it { expect { post :create, params: {project_id: project.id, task: task.attributes} }.to change(Task, :count).by(1) }
      end
    end

    describe '#edit' do
      before { get :edit, params: {id: task.id} }

      it { is_expected.to have_http_status 200 }
      it { expect(assigns(:task).id).to eq task.id }
    end

    describe '#update' do
      before { patch :update, params: {id: task.id, project: task2.attributes} }

      let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('user_id') }.tap { |attrs| attrs.delete('project_id') } } }

      it { is_expected.to redirect_to task }
      xit { expect(remove_meta.call(Task.find(task.id).attributes)).to eq remove_meta.call(task2.attributes) }
    end

    describe '#destroy' do
      describe 'Redirect and destroy the record' do
        before { delete :destroy, params: {id: task.id} }

        it { is_expected.to redirect_to [project, :tasks] }
        it { expect(Task.find_by(id: task.id)).to be_nil }
      end

      describe 'Destroy a record' do
        before { task }

        it { expect { delete :destroy, params: {id: task.id} }.to change(Task, :count).by(-1) }
      end
    end
  end
end
