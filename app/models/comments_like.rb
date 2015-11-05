class CommentsLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment, counter_cache: :likes_count

end
