class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_many :launched_projects, dependent: :destroy, class_name: 'Project', foreign_key: 'creator_id'
  has_many :projects, through: :project_user_relations
  has_many :project_user_relations, dependent: :destroy

  validates :nickname, presence: true
end
