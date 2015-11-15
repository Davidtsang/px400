class AddCommentsCountToWorks < ActiveRecord::Migration
  def change
    add_column :works, :comments_count, :integer, :default => 0
  end
end
