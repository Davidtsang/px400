require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
    @work = @user.works.build(desciption: "Lorem ipsum", image: "/fakeimagepath.jpg")
  end

  test "should be valid" do
    assert @work.valid?
  end

  test "user id should be present" do
    @work.user_id = nil
    assert_not @work.valid?
  end

  test "image should be present" do
    @work.image = nil
    assert_not @work.valid?
  end

  test "order should be most recent first" do
    assert_equal Work.first, works(:most_recent)
  end
end
