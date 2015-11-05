class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :work_id
      t.integer :likes_count, default: 0
      t.timestamps null: false
    end
  end
end
