require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.works.create!(image: "/fake.jpg")
    assert_difference 'Work.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:one)
    archer = users(:two)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end


  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end

    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
