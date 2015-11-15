class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :type
      t.integer :obj_id
      t.integer :break_rule
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
