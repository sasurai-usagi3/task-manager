class GroupUserRelation < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum authority: {general: 0, owner: 1, administrator: 2}

  validates :group, presence: true
  validates :user, presence: true
  validates :authority, presence: true
end
