require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  subject { response }

  before { sign_in user }

  let(:user) { create(:user) }

  describe '#index' do
    before { get :index }

    it { is_expected.to have_http_status 200 }
  end
end
