class AddRepostCountToWorks < ActiveRecord::Migration
  def change
    add_column :works, :repost_count, :integer, default: 0

  end
end
