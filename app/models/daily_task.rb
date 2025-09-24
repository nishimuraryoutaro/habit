class DailyTask < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  validates :title, length: { maximum: 255 }
end
