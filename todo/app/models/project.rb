class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :users, through: :project_user_relations
  has_many :project_user_relations, dependent: :destroy

  validates :creator, presence: true
  validates :name, presence: true
end
