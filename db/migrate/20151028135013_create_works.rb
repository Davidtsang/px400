class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title
      t.string :image
      t.text :desciption
      t.integer :user_id
      t.integer :views_count, default: 0
      t.integer :likes_count, default: 0
      t.integer :favorites_count, default: 0
      t.integer :shares_count, default: 0

      t.timestamps null: false
    end
      add_index :works, [:user_id, :created_at]
  end
end
