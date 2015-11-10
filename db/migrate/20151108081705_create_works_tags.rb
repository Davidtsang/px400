class CreateWorksTags < ActiveRecord::Migration
  def change
    create_table :works_tags do |t|
      t.integer :work_id, null: false
      t.integer :tag_id, null: false

      t.timestamps null: false
    end

    add_index :works_tags, [:work_id, :tag_id], unique: true

  end
end
