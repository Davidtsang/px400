class UsersTag < ActiveRecord::Base
  belongs_to :tag, counter_cache: :items_count
  belongs_to :user
  validates_presence_of :user_id, :tag_id

  validates_uniqueness_of :user_id , scope: :tag_id

end
