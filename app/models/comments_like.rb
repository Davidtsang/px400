class CommentsLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment, counter_cache: :likes_count

  validates_uniqueness_of :comment_id , scope: :user_id

end
