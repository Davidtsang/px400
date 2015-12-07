class CreateSiteConfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :name
      t.string :the_key
      t.string :the_value

      t.timestamps null: false
    end

    add_index :site_configs, :the_key, unique: true

  end
end
