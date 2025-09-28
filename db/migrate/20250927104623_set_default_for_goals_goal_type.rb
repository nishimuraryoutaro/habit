class SetDefaultForGoalsGoalType < ActiveRecord::Migration[8.0]
  def up
    execute "UPDATE goals SET goal_type = 0 WHERE goal_type IS NULL"
    change_column_default :goals, :goal_type, from: nil, to: 0
    change_column_null    :goals, :goal_type, false
    add_index :goals, :goal_type unless index_exists?(:goals, :goal_type)
  end

  def down）
    change_column_null    :goals, :goal_type, true
    change_column_default :goals, :goal_type, from: 0, to: nil
    remove_index :goals, :goal_type if index_exists?(:goals, :goal_type)
  end
end
