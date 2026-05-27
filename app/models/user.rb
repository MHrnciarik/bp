class User < ApplicationRecord
  LOGIN_STREAK_REWARDS = {
    3 => 100,
    7 => 250
  }.freeze
  ACHIEVEMENT_COUNT_REWARDS = {
    5 => 50,
    10 => 100,
    15 => 150,
    20 => 250
  }.freeze

  has_secure_password
  has_many :companies, dependent: :destroy
  has_many :mission_progresses, dependent: :destroy
  has_many :user_achievements, dependent: :destroy

  before_validation :normalize_email

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :xp, numericality: { greater_than_or_equal_to: 0 }
  validates :login_count, numericality: { greater_than_or_equal_to: 0 }
  validates :current_login_streak, numericality: { greater_than_or_equal_to: 0 }
  validates :total_login_days, numericality: { greater_than_or_equal_to: 0 }

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

  def login_streak_day_count
    streak = current_login_streak.to_i
    return 0 if streak.zero?

    ((streak - 1) % 7) + 1
  end

  def login_streak_reward_claimable?(day)
    LOGIN_STREAK_REWARDS.key?(day.to_i) &&
      current_login_streak.to_i >= day.to_i &&
      !login_streak_reward_claimed?(day)
  end

  def login_streak_reward_claimed?(day)
    case day.to_i
    when 3
      login_streak_reward_3_claimed_at.present?
    when 7
      login_streak_reward_7_claimed_at.present?
    else
      false
    end
  end

  def mark_login_streak_reward_claimed!(day)
    case day.to_i
    when 3
      update!(login_streak_reward_3_claimed_at: Time.current)
    when 7
      update!(login_streak_reward_7_claimed_at: Time.current)
    else
      raise ArgumentError, "Unknown login streak reward"
    end
  end

  def achievement_count_reward_claimed?(target)
    achievement_count_reward_claimed_at(target).present?
  end

  def mark_achievement_count_reward_claimed(target)
    public_send(:"achievement_reward_#{target}_claimed_at=", Time.current)
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase.presence
  end

  def achievement_count_reward_claimed_at(target)
    case target.to_i
    when 5
      achievement_reward_5_claimed_at
    when 10
      achievement_reward_10_claimed_at
    when 15
      achievement_reward_15_claimed_at
    when 20
      achievement_reward_20_claimed_at
    end
  end
end
