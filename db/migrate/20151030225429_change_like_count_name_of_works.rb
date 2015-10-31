class ChangeLikeCountNameOfWorks < ActiveRecord::Migration
  def change
    rename_column :works, :likes_count, :works_likes_count
  end
end
