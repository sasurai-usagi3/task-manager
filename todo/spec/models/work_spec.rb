require 'rails_helper'

RSpec.describe Work, type: :model do
  describe 'Association' do
    it { should belong_to(:project) }
    it { should belong_to(:task) }
    it { should belong_to(:user) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:task) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).only_integer }
  end
end
