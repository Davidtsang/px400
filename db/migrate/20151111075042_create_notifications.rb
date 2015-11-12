class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :subject_id
      t.string :type
      t.integer :user_id ,null: false
      t.integer :obj_id
      t.boolean :is_checked, default: false

      t.timestamps null: false
    end

    add_index :notifications, :user_id

  end
end
