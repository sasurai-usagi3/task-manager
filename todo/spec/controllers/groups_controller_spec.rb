require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  subject { response }

  let(:group) { create(:group) }
  let(:group2) { create(:group) }
  let(:user) { create(:user) }

  context '非ログイン時' do
    shared_examples_for 'redirect to sign in' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    describe '#new' do
      before { get :new }

      it_behaves_like 'redirect to sign in'
    end

    describe '#create' do
      before { post :create, params: {group: group.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#edit' do
      before { get :edit, params: {id: group.id} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#update' do
      before { patch :update, params: {id: group.id, project: group2.attributes} }

      it_behaves_like 'redirect to sign in'
    end

    describe '#destroy' do
      before { delete :destroy, params: {id: group.id} }

      it_behaves_like 'redirect to sign in'
    end
  end

  context '権限が不足しているとき' do
    before { sign_in user }

    describe '#edit' do
      it { expect { get :edit, params: {id: group.id} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#update' do
      it { expect { patch :update, params: {id: group.id, project: group2.attributes} }.to raise_error Pundit::NotAuthorizedError }
    end

    describe '#destroy' do
      it { expect { delete :destroy, params: {id: group.id} }.to raise_error Pundit::NotAuthorizedError }
    end
  end

  context '権限を持っているとき' do
    before { sign_in user }

    describe '#new' do
      before { get :new }

      it { is_expected.to have_http_status 200 }
    end

    describe '#create' do
      describe 'Redirect and so on' do
        before { post :create, params: {group: group.attributes} }

        it { is_expected.to redirect_to [Group.last, :projects] }

        it '作成者が管理者になっていること' do
          project_user_relation = GroupUserRelation.last

          expect(project_user_relation.user_id).to eq user.id
          expect(project_user_relation.owner?).to be_truthy
        end
      end

      describe 'Create a record' do
        let(:group) { build(:group) }

        it { expect { post :create, params: {group: group.attributes} }.to change(Group, :count).by(1) }
        it { expect { post :create, params: {group: group.attributes} }.to change(GroupUserRelation, :count).by(1) }
      end
    end

    describe '#edit' do
      before { group.group_user_relations.create!(user: user, authority: 'owner') }
      before { get :edit, params: {id: group.id} }

      it { is_expected.to have_http_status 200 }
      it { expect(assigns(:group).id).to eq group.id }
    end

    describe '#update' do
      before { group.group_user_relations.create!(user: user, authority: 'owner') }
      before { patch :update, params: {id: group.id, project: group2.attributes} }

      let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('creator_id') } } }

      it { is_expected.to redirect_to [group, :projects] }
      xit { expect(remove_meta.call(Group.find(group.id).attributes)).to eq remove_meta.call(group2.attributes) }
    end

    describe '#destroy' do
      before { group.group_user_relations.create!(user: user, authority: 'owner') }

      describe 'Redirect and destroy the record' do
        before { delete :destroy, params: {id: group.id} }

        it { is_expected.to redirect_to '/' }
        it { expect(Group.find_by(id: group.id)).to be_nil }
      end

      describe 'Destroy a record' do
        before { group }

        it { expect { delete :destroy, params: {id: group.id} }.to change(Group, :count).by(-1) }
      end
    end
  end
end
