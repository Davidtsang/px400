require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @comment = Comment.new(work_id: 1, user_id:1 , content: "test")
  end

  test "should be valid" do
    assert @comment.valid?

  end

  test "content nil should be valid" do
    @comment.content =""
    assert_not  @comment.valid?

    @comment.content = nil
    assert_not  @comment.valid?

  end

  test "remove comment the comment_likes should be remove too" do
    @comment.save

    cid = @comment.id
    CommentsLike.create!(comment_id: @comment.id ,user_id: 1)

    @comment.destroy

    assert_equal 0, CommentsLike.where(comment_id: cid , user_id: 1 ).count
  end
end
