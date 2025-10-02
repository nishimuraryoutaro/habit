class Goal < ApplicationRecord
  belongs_to :user
  has_many :daily_tasks, dependent: :destroy
  validates :title, :start_date, :target_date, presence: true
  validate :start_before_target

  scope :three_month, -> { where(goal_type: 0) }
  scope :one_month,   -> { where(goal_type: 1) }

  private
  def start_before_target
    if start_date.blank? || target_date.blank?
    else
      if target_date <= start_date
        errors.add(:target_date, "は開始日より後の日付にしてください")
      end
    end
  end
end
