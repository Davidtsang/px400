class Favorite < ActiveRecord::Base
  belongs_to :favorite_folder
  belongs_to :work, counter_cache: true


  validates_uniqueness_of :work_id, :scope => :favorite_folder_id

end
