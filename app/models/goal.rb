class Goal < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  scope :three_month, -> { where(goal_type: 0) }   # 値は運用に合わせて
  scope :one_month,   -> { where(goal_type: 1) }
end
