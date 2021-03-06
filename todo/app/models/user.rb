class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_many :group_user_relations, dependent: :destroy
  has_many :joined_groups, through: :group_user_relations, source: :group
  has_many :project_user_relations, dependent: :destroy
  has_many :joined_projects, through: :project_user_relations, source: :project
  has_many :launched_projects, dependent: :destroy, class_name: 'Project', foreign_key: 'creator_id'
  has_many :tasks, dependent: :destroy
  has_many :works, dependent: :destroy

  validates :nickname, presence: true
end
