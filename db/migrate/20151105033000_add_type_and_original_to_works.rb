class AddTypeAndOriginalToWorks < ActiveRecord::Migration
  def change
    add_column :works , :is_original, :boolean, default: false
    add_column :works , :work_type, :string, default: "new"
    add_column :works , :parent_work_id, :integer, default: nil

  end
end
