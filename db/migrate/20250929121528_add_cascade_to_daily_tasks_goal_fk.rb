class AddCascadeToDailyTasksGoalFk < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :daily_tasks, :goals
    add_foreign_key :daily_tasks, :goals, on_delete: :cascade
  end

  def down
    remove_foreign_key :daily_tasks, :goals
    add_foreign_key :daily_tasks, :goals
  end
end