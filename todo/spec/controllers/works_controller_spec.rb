require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  subject { response }

  let(:project) { create(:project) }
  let(:task) { create(:task, project: project) }
  let(:work) { create(:work, project: project, task: task) }
  let(:work2) { create(:work, amount: 10) }
  let(:user) { create(:user) }
  let(:user2) { create(:user, joined_projects: [project]) }

  context '非ログイン時' do
    shared_examples_for 'redirect to sign in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe '#index' do
      before { get :index, params: {project_id: project.id, user_id: user.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#create' do
      before { post :create, params: {task_id: task.id, work: work.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#edit' do
      before { get :edit, params: {id: work.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#update' do
      before { patch :update, params: {id: work.id, work: work2.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#destroy' do
      before { delete :destroy, params: {id: work.id} }

      it_behaves_like 'redirect to sign in'
    end
  end

  context '権限不足' do
    before { sign_in user }

    describe '#index' do
      it { expect { get :index, params: {project_id: project.id, user_id: user2.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#create' do
      it { expect { post :create, params: {task_id: task.id, work: work.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#edit' do
      it { expect { get :edit, params: {id: work.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#update' do
      it { expect { patch :update, params: {id: work.id, work: work2.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#destroy' do
      it { expect { delete :destroy, params: {id: work.id} }.to raise_error Pundit::NotAuthorizedError }
    end
  end

  context '権限を持っている時' do
    before do
      sign_in user
      project.project_user_relations.create!(user: user, authority: 'administrator')
    end

    describe '#index' do
      before { get :index, params: {project_id: project.id, user_id: user2.id} }

      it { is_expected.to have_http_status 200 }
    end

    describe '#create' do
      describe 'Redirect and so on' do
        before { post :create, params: {task_id: task.id, work: work.attributes}, format: 'js' }

        it { is_expected.to have_http_status 201 }
        it { is_expected.to render_template('list') }
      end

      describe 'Create a record' do
        let(:work) { build(:work) }

        it { expect { post :create, params: {task_id: task.id, work: work.attributes}, format: 'js' }.to change(Work, :count).by(1) }
      end
    end

    describe '#edit' do
      before { get :edit, params: {id: work.id} }

      it { is_expected.to have_http_status 200 }
      it { expect(assigns(:work).id).to eq work.id }
    end

    describe '#update' do
      before { patch :update, params: {id: work.id, work: work2.attributes}, format: 'js' }

      let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('user_id') }.tap { |attrs| attrs.delete('project_id') }.tap { |attrs| attrs.delete('user_id') } } }

      it { is_expected.to have_http_status 202 }
      it { is_expected.to render_template 'list' }
      xit { expect(remove_meta.call(Work.find(work.id).attributes)).to eq remove_meta.call(work2.attributes) }
    end

    describe '#destroy' do
      describe 'Redirect and destroy the record' do
        before { delete :destroy, params: {id: work.id}, format: 'js' }

        it { is_expected.to have_http_status 202 }
        it { is_expected.to render_template 'list' }
        it { expect(Work.find_by(id: work.id)).to be_nil }
      end

      describe 'Destroy a record' do
        before { work }

        it { expect { delete :destroy, params: {id: work.id}, format: 'js' }.to change(Work, :count).by(-1) }
      end
    end
  end
end
