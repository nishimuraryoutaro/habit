class CreateDailyTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :goal, null: false, foreign_key: true
      t.string :title
      t.date :date
      t.boolean :done

      t.timestamps
    end
  end
end
