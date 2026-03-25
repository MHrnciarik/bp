class User < ApplicationRecord
  has_secure_password
  has_many :companies, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
