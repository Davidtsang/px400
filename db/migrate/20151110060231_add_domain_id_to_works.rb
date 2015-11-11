class AddDomainIdToWorks < ActiveRecord::Migration
  def change
    add_column :works, :domain_id, :integer

  end
end
