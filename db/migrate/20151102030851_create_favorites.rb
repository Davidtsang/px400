class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :work_id
      t.integer :favorite_folder_id

      t.timestamps null: false
    end

    add_index :favorites, [:work_id, :favorite_folder_id],unique: true

  end
end
