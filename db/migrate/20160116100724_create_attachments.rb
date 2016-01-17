class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :media
      t.string :name
      t.integer :work_id

      t.timestamps null: false
    end
  end
end
