class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.text :content
      t.boolean :is_read , default: false

      t.timestamps null: false
    end
    add_index :messages, :from_user_id
    add_index :messages, :to_user_id

  end
end
