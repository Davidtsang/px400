require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @notification = Notification.new(user_id: 1)

  end


  test "should be valid " do

    assert @notification.valid?

  end

  test "user id should be present" do

     @notification.user_id = nil

    assert_not  @notification.valid?

  end

  test "uncheck_notify_by_user_id should be right behave" do

    @notification.save

    assert_equal @notification.id , Notification.uncheck_notify_by_user_id(1).first.id

  end
end
