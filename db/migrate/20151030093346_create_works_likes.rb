class CreateWorksLikes < ActiveRecord::Migration
  def change
    create_table :works_likes do |t|
      t.integer :work_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :works_likes,[:work_id, :user_id], unique: true

  end
end
