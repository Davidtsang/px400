class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.integer :user_id
      t.string :act
      t.integer :work_id
      t.string :note

      t.timestamps null: false
    end

  end
end
