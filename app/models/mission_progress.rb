class MissionProgress < ApplicationRecord
  belongs_to :user

  validates :mission_key, presence: true
  validates :period, presence: true
  validates :period_start, presence: true
  validates :progress, numericality: { greater_than_or_equal_to: 0 }

  def definition
    MissionCatalog.fetch(period, mission_key)
  end

  def title
    definition[:title]
  end

  def target
    definition[:target]
  end

  def xp_reward
    definition[:xp]
  end

  def completed?
    progress >= target
  end

  def claimable?
    completed? && claimed_at.nil?
  end

  def claimed?
    claimed_at.present?
  end
end
