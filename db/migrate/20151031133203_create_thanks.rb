class CreateThanks < ActiveRecord::Migration
  def change
    create_table :thanks do |t|
      t.integer :user_id
      t.integer :work_id

      t.timestamps null: false
    end

    add_index :thanks,[:work_id, :user_id], unique: true
  end
end
