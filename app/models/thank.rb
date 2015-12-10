class Thank < ActiveRecord::Base
  belongs_to :work , :counter_cache=> true
  belongs_to :user
  validates_presence_of :user_id, :work_id
  validates_uniqueness_of :user_id, :scope => :work_id
end
