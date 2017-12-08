require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validation' do
    it { should validate_presence_of(:nickname) }
  end
end
