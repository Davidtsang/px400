class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :desciption
      t.string :type
      t.integer :parent_id
      t.integer :status, default: 0
      t.string :icon
      t.integer :items_count
      t.timestamps null: false

    end

    add_index :tags, :name

  end
end
