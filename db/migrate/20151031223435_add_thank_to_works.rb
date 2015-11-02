class AddThankToWorks < ActiveRecord::Migration
  def change
    add_column :works , :thanks_count ,:integer,:default => 0

  end
end
