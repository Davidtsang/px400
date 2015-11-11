class AddDomainsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :domain_1_id, :integer
    add_column :users, :domain_2_id, :integer
  end
end
