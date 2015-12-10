class Report < ActiveRecord::Base
  validates_presence_of :user_id , :obj_id, :type

end
