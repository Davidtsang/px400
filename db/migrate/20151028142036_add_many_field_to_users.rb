class AddManyFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :location, :string
    add_column :users, :title, :string
    add_column :users, :company,:string
    add_column :users, :sex, :integer
    add_column :users, :avatar, :string
    add_column :users, :fans_count, :integer
    add_column :users, :bio, :string
    add_column :users, :website, :string

  end
end
