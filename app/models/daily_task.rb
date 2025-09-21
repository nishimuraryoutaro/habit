class DailyTask < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  validates :title, :date, presence: true
end
