class Goal < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :title, :start_date, :target_date, presence: true

  scope :three_month, -> { where(goal_type: 0) }
  scope :one_month,   -> { where(goal_type: 1) }

  private
  def start_before_target
    if start_date.blank? || target_date.blank? && start_date > target_date
      errors.add(:start_date, "は目標日より前の日付を指定してください")
    end
  end
end
