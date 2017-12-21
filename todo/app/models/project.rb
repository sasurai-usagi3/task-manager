class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :group
  has_many :tasks, dependent: :destroy
  has_many :project_user_relations, dependent: :destroy
  has_many :users, through: :project_user_relations
  has_many :works, dependent: :destroy

  validates :creator, presence: true
  validates :name, presence: true
end
