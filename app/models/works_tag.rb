class WorksTag < ActiveRecord::Base
  belongs_to :work
  belongs_to :tag
  validates_presence_of :tag_id, :work_id

end
