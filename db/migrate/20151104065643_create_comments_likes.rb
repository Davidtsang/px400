class CreateCommentsLikes < ActiveRecord::Migration
  def change
    create_table :comments_likes do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps null: false
    end

    add_index :comments_likes , [:user_id, :comment_id], unique: true

  end
end
