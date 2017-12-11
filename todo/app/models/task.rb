class Task < ApplicationRecord
  belongs_to :group
  belongs_to :project
  belongs_to :user

  enum status: {not_start: 0, in_progress: 1, done: 2}

  validates :project, presence: true
  validates :user, presence: true
  validates :title, presence: true
  validates :priority, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than: 100}
  validates :status, presence: true
end
