require 'test_helper'

class ThankTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @thank  = Thank.new(user_id:1 , work_id: 1)
  end

  test "should be valid " do

    assert @thank.valid?

  end

  test "user_id/work_id should be unqieness" do
    @thank.save

    t  =  Thank.new(user_id:1 , work_id: 1)

    assert_not t.valid?

  end
end
