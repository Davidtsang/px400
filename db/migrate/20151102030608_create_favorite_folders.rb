class CreateFavoriteFolders < ActiveRecord::Migration
  def change
    create_table :favorite_folders do |t|
      t.integer :user_id
      t.string :name
      t.integer :favorites_count

      t.timestamps null: false
    end
  end
end
