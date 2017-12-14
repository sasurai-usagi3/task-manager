class Group < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :group_user_relations, dependent: :destroy
  has_many :members, through: :group_user_relations, source: :user
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :creator, presence: true
  validates :name, presence: true
end
