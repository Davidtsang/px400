class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title
      t.string :image
      t.text :desciption
      t.integer :user_id
      t.integer :views_count
      t.integer :likes_count
      t.integer :favorites_count
      t.integer :shares_count

      t.timestamps null: false
    end
  end
end
