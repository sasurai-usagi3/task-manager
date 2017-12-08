class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  validates :nickname, presence: true
end
