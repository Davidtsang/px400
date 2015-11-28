class CreateIcodes < ActiveRecord::Migration
  def change
    create_table :icodes do |t|
      t.string :code
      t.integer :user_id
      t.boolean :is_used , default: false
      t.integer :used_user_id

      t.timestamps null: false
    end
  end
end
