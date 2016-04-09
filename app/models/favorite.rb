class Favorite < ActiveRecord::Base
  belongs_to :favorite_folder, counter_cache: true
  belongs_to :work, counter_cache: true


  validates_uniqueness_of :work_id, :scope => :favorite_folder_id


end
