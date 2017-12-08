class ProjectUserRelation < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum authority: {general: 0, administrator: 1}

  validates :project, presence: true
  validates :user, presence: true
  validates :authority, presence: true
end
