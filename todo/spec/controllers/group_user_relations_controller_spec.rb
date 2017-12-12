require 'rails_helper'

RSpec.describe GroupUserRelationsController, type: :controller do
  subject { response }

  before do
    sign_in user
    GroupUserRelation.create!(user: user, group: group, authority: 'owner')
  end

  let(:group) { create(:group) }
  let(:group_user_relation) { group.group_user_relations.create!(user: user2) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

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
      before { post :create, params: {group_id: group.id, group_user_relation: {user_id: user2.id, authority: 'administrator'}} }

      it { is_expected.to redirect_to [group, :group_user_relations] }
    end

    describe 'Create a record' do
      it { expect { post :create, params: {group_id: group.id, group_user_relation: {user_id: user2.id}} }.to change(GroupUserRelation, :count).by(1) }
    end
  end

  describe '#edit' do
    before { get :edit, params: {id: group_user_relation.id} }

    it { is_expected.to have_http_status 200 }
    it { expect(assigns(:group_user_relation).id).to eq group_user_relation.id }
  end

  describe '#update' do
    before { patch :update, params: {id: group_user_relation.id, group_user_relation: {authority: 'general'}} }

    let(:remove_meta) { lambda { |data| data.tap { |attrs| attrs.delete('id') }.tap { |attrs| attrs.delete('created_at') }.tap { |attrs| attrs.delete('updated_at') }.tap { |attrs| attrs.delete('group_id') } } }

    it { is_expected.to redirect_to [group, :group_user_relations] }
    it { expect(GroupUserRelation.find(group_user_relation.id).authority).to eq 'general' }
  end

  describe '#destroy' do
    describe 'Redirect and destroy the record' do
      before { delete :destroy, params: {id: group_user_relation.id} }

      it { is_expected.to redirect_to [group, :group_user_relations] }
      it { expect(GroupUserRelation.find_by(id: group_user_relation.id)).to be_nil }
    end

    describe 'Destroy a record' do
      before { group_user_relation }

      it { expect { delete :destroy, params: {id: group_user_relation.id} }.to change(GroupUserRelation, :count).by(-1) }
    end
  end
end
