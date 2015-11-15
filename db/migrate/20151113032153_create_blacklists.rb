class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :user_id
      t.integer :block_user_id

      t.timestamps null: false
    end

    add_index :blacklists, [:user_id, :block_user_id], unique: true

  end
end
