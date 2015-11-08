class UsersTag < ActiveRecord::Base
  belongs_to :tag, counter_cache: :items_count
  belongs_to :user
end
