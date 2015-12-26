class Comment < ActiveRecord::Base

  after_destroy :destroy_notify
  belongs_to :work , :counter_cache => true
  belongs_to :user

  validates :content ,presence: true

  has_many :comments_likes, dependent: :destroy

  belongs_to :parent, :class_name => 'Comment', :foreign_key =>  "parent_id"

  private

  def destroy_notify

    CommentsWorkNotify.destroy_all(obj_id: id)
    ReplyCommentNotify.destroy_all(obj_id: id)

  end

end
