class User < ApplicationRecord
  has_secure_password
  has_many :companies, dependent: :destroy
  has_many :mission_progresses, dependent: :destroy
  has_many :user_achievements, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :xp, numericality: { greater_than_or_equal_to: 0 }
  validates :login_count, numericality: { greater_than_or_equal_to: 0 }

  def level
    (xp / 250) + 1
  end

  def xp_in_current_level
    xp % 250
  end

  def xp_for_next_level
    250
  end

  def xp_progress_percentage
    ((xp_in_current_level.to_f / xp_for_next_level) * 100).round
  end
end
