require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @message = Message.new(content: "test", from_user_id: 1, to_user_id: 2 )
  end

  test "should be vaild" do

    assert @message.valid?

  end

  test "content should be present" do

    @message.content = ""

    assert_not @message.valid?

  end

  test "to user id should be present" do

    @message.to_user_id= nil

    assert_not @message.valid?

  end

  test "from user id should be present" do

    @message.from_user_id= nil

    assert_not @message.valid?

  end

  test "receive_default should be right behave" do
    @message.status= -1
    @message.save
    assert_equal 0, Message.receive_default.count

    @message.status= 0
    @message.save
    assert_equal 1, Message.receive_default.count
  end
end
