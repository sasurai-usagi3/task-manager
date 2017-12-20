class Work < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :user

  validates :project, presence: true
  validates :task, presence: true
  validates :user, presence: true
  validates :title, presence: true
  validates :amount, presence: true, numericality: {only_integer: true}
end
