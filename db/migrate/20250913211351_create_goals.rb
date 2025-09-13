class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.date :start_date
      t.date :target_date
      t.text :description

      t.timestamps
    end
  end
end
