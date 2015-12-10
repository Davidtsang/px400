class UsersTag < ActiveRecord::Base
  belongs_to :tag, counter_cache: :items_count
  belongs_to :user

  validates_uniqueness_of :user_id , scope: :tag_id

end
