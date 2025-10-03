class AddSubGoalsToGoals < ActiveRecord::Migration[8.0]
  def change
    add_column :goals, :one_month_title, :string
    add_column :goals, :one_week_title, :string
  end
end
