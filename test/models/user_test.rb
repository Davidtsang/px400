require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def create_user_two
    icode = icodes(:three)
    user = User.create!(name: "Example User 2", email: "user2@test.com",
                        password: "password", password_confirmation: "password", icode: icode.code)
    user
  end

  def create_user_three
    icode = icodes(:four)
    user = User.create!(name: "Example User 3", email: "user3@test.com",
                        password: "password", password_confirmation: "password", icode: icode.code)
    user
  end

  def setup
    @icode = icodes(:one)
    @user = User.new(name: "Example User", email: "user@test.com",
                     password: "password", password_confirmation: "password", icode: @icode.code)
  end

  test "should be valid" do
    assert @user.valid?
    @user.errors.messages
  end

  test "icode error should not valid" do
    @user.icode ="fake"
    assert_not @user.valid?
  end

  test "icode nil should not valid" do
    @user.icode = nil
    assert_not @user.valid?
  end

  test "icode have space should be auto remove" do
    @user.icode = @user.icode + " "
    assert @user.valid?
  end

  test "icode is used should not valid" do
    icode2 = icodes(:two)
    user = User.new(name: "Example User2", email: "user2@test.com",
                    password: "password", password_confirmation: "password", icode: icode2.code)
    assert_not user.valid?
  end

  test "fake email addresss should not vaild " do
    @user.email = "1#1.com"
    assert_not @user.valid?
  end

  test "name to long >32 shoult not vaild" do
    @user.name = "a" * 33
    assert_not @user.valid?
  end

  test "name too short 2 shoult not vaild" do
    @user.name = "a"
    assert_not @user.valid?
  end

  test "name no persence shoult not vaild" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "password too short shoult not vaild" do
    @user.password = "1234567"
    @user.password_confirmation = "1234567"
    assert_not @user.valid?
  end

  test "password too long shoult not vaild" do
    @user.password = "a" * 257
    @user.password_confirmation = "a" * 257
    assert_not @user.valid?
  end

  test "password shoult vaild" do
    @user.password = "a" * 22
    @user.password_confirmation = "a" * 22
    assert @user.valid?
  end

  #--------------part ii
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "should not a user follow themself" do
    michael = users(:michael)
    assert_not michael.following?(michael)
    michael.follow(michael)
    assert_not michael.following?(michael)

  end

  test "user role should be artist" do
    icode = icodes(:three)
    user = User.create(name: "Example User", email: "user@test3.com",
                       password: "password", password_confirmation: "password", icode: icode.code)
    #puts "----:("
    #puts user.name
    assert_equal 'artist', user.user_role
  end

  test "nickname should not repeat" do
    @user.nickname = "david"
    @user.save
    icode = icodes(:three)
    user = User.new(name: "Example User", email: "user@test3.com", nickname: "david",
                    password: "password", password_confirmation: "password", icode: icode.code)

    assert_not user.valid?

  end

  test "nickname should be right format" do
    @user.nickname = "david"
    assert @user.valid?

    @user.nickname = "da vid"
    assert_not @user.valid?

    @user.nickname = "da#vid"
    assert_not @user.valid?

    @user.nickname = "da@vid"
    assert_not @user.valid?

    @user.nickname = "da/vid"
    assert_not @user.valid?

    @user.nickname = "da%vid"
    assert_not @user.valid?

    @user.nickname = "da!vid"
    assert_not @user.valid?

    @user.nickname = "da&vid"
    assert_not @user.valid?

  end

  test "nickname should be 2~32 length" do
    @user.nickname= "d"
    assert_not @user.valid?

    @user.nickname= "d" * 33
    assert_not @user.valid?
  end

  test "used icode should be false" do
    icode = icodes(:three)
    User.create(name: "Example User", email: "user@test3.com", nickname: "david3",
                password: "password", password_confirmation: "password", icode: icode.code)
    icode.reload
    assert_equal true, icode.is_used

  end

  test "new user should be got some icodes" do
    icode = icodes(:three)
    user = User.create(name: "Example User", email: "user@test3.com", nickname: "david3",
                       password: "password", password_confirmation: "password", icode: icode.code)

    users_icodes = Icode.where(user_id: user.id).count

    sf = site_configs(:one)

    assert_equal sf.the_value.to_i, users_icodes
  end

  test "user destroy the works_likes should be destroy too" do
    user2 = create_user_two
    wl =WorksLike.create(work_id: 343, user_id: user2.id)
    #puts "....:)"
    #puts user2.id

    wl_id = wl.id
    user2.destroy

    assert_equal 0, WorksLike.where(id: wl_id).count

  end

  test "user destroy the thanks should be destroy too" do
    user2 = create_user_two
    t =Thank.create(work_id: 343, user_id: user2.id)

    t_id = t.id
    user2.destroy

    assert_equal 0, Thank.where(id: t_id).count
  end

  test "user destroy the favorite_folders should be destroy too" do
    user2 = create_user_two
    ff =FavoriteFolder.create(name: "test", user_id: user2.id)

    ff_id = ff.id
    user2.destroy

    assert_equal 0, FavoriteFolder.where(id: ff_id).count

  end

  test "user destroy the comments should be destroy too" do
    user2 = create_user_two
    c =Comment.create(content: "test", work_id: 1, user_id: user2.id)

    c_id = c.id
    user2.destroy

    assert_equal 0, Comment.where(id: c_id).count
  end

  test "user destroy the comments_likes should be destroy too" do
    user2 = create_user_two
    cl =CommentsLike.create(comment_id: 1, user_id: user2.id)

    cl_id = cl.id
    user2.destroy

    assert_equal 0, CommentsLike.where(id: cl_id).count

  end

  test "user destroy the blacklists should be destroy too" do
    user2 = create_user_two
    bl =Blacklist.create(block_user_id: 222, user_id: user2.id)

    bl_id = bl.id
    user2.destroy

    assert_equal 0, Blacklist.where(id: bl_id).count
  end

  test "user destroy the notifications should be destroy too" do
    user2 = create_user_two
    n =Notification.create!(user_id: user2.id)

    n_id = n.id
    user2.destroy

    assert_equal 0, Notification.where(id: n_id).count
  end

  test "user destroy the users_tags should be destroy too" do
    user2 = create_user_two
    ut =UsersTag.create!(user_id: user2.id, tag_id: 123)

    ut_id = ut.id
    user2.destroy

    assert_equal 0, UsersTag.where(id: ut_id).count
  end

  test "user destroy the send_messages should be destroy too" do
    user2 = create_user_two
    user2.send_messages.create!(content: "test", to_user_id: 123)

    user2.destroy

    assert_equal 0, Message.where(from_user_id: user2.id).count
  end

  test "user destroy the receive_messages should be destroy too" do
    user2 = create_user_two
    user2.receive_messages.create!(content: "test", from_user_id: 123)

    user2.destroy

    assert_equal 0, Message.where(to_user_id: user2.id).count
  end

  test "user destroy the active_relationships should be destroy too" do
    user2 = create_user_two
    user2.active_relationships.create!(followed_id: 123)

    user2.destroy

    assert_equal 0, Relationship.where(follower_id: user2.id).count
  end

  test "user destroy the passive_relationships should be destroy too" do
    user2 = create_user_two
    user2.passive_relationships.create!(follower_id: 123)

    user2.destroy

    assert_equal 0, Relationship.where(followed_id: user2.id).count

  end

  test "user destroy the icodes should be destroy too" do
    user2 = create_user_two

    user2.destroy

    assert_equal 0, Icode.where(user_id: user2.id).count
  end

  test "user destroy the work should be destroy too" do
    user2 = create_user_two #File.open(Dir["#{Rails.root}/public/fake-work.jpg"])
    user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))

    user2.destroy
    assert_equal 0, Work.where(user_id: user2.id).count
  end

  test "recent work should be right order" do
    user2 = create_user_two
    work1 = user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    work2 = user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    #user2.destroy
    recent_work = user2.recent_works
    assert_equal work1.id, recent_work[1].id
    assert_equal work2.id, recent_work[0].id
  end

  test "blocked? should be right behave" do
    user2 = create_user_two
    bl =user2.blacklists.create!(block_user_id: 333)
    assert user2.blocked?(333)

    user2.blacklists.find(bl.id).destroy
    assert_not user2.blocked?(333)
  end

  test "user block a uses should be unfollow" do
    user2 = create_user_two
    user3 = create_user_three
    user3.follow(user2)

    Blacklist.block_user(user2, user3)

    assert_not user3.following?(user2)

  end

  test "follow /unfollow /following? should be right behave" do
    user2 = create_user_two
    user3 = create_user_three
    user2.follow(user3)

    assert_equal 1 , Relationship.where(followed_id: user3.id ,follower_id: user2.id ).count
    assert user2.following?(user3)

    user2.unfollow(user3)
    assert_equal 0 , Relationship.where(followed_id: user3.id ,follower_id: user2.id ).count
    assert_not  user2.following?(user3)
  end

  test "follow should not follow self" do
    user2 = create_user_two

    user2.follow(user2)

    assert_equal 0 , Relationship.where(followed_id: user2.id ,follower_id: user2.id ).count

  end

  test "is_admin? should be right behave" do
    user2 = create_user_two
    user2.user_role ="admin"

    assert user2.is_admin?

    user2.user_role ="artist"

    assert_not user2.is_admin?

  end

  #test get all users by skill id

  test "self.all_by_skill_id should be right behave" do
      user2  = create_user_two
      user3 = create_user_three

      #add skill
      skills = Skill.create!(name: "ios")
      UsersTag.create!(tag_id: skills.id , user_id: user2.id )
      UsersTag.create!(tag_id: skills.id , user_id: user3.id )

      users = User.all_by_skill_id(skills.id)

      assert_equal 2, users.count

  end

  test "self.all_by_domain_id_and_skill_id should be right behave" do
    user2  = create_user_two
    user3 = create_user_three

    #add domain
    user2.domain_1_id = 1
    user3.domain_1_id = 2

    user2.save
    user3.save

    #add skill
    skills = Skill.create!(name: "ios")
    UsersTag.create!(tag_id: skills.id , user_id: user2.id )
    UsersTag.create!(tag_id: skills.id , user_id: user3.id )

    #domian id =1 ,skill = nil
    users_test1 =User.all_by_domain_id_and_skill_id(1)
    assert_equal user2.id, users_test1.first.id

    #domain id = 2, skill = ios
    users_test2 = User.all_by_domain_id_and_skill_id(2, skills.id)
    assert_equal user3.id , users_test2.first.id

    #error domain id
    users_test3 = User.all_by_domain_id_and_skill_id(3)
    assert_equal 0, users_test3.count

  end

  test "user_feed_by_tag_id should be right behave" do
    user2  = create_user_two
    #create a work and tag
    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    WorksTag.create!(work_id: work.id ,tag_id: 333)
    timeline =user2.timelines.create(work_id: work.id, act: "new")
    feed = user2.user_feed_by_tag_id(333)

    assert_equal work.id , feed.first.work.id
    assert_equal timeline.id , feed.first.id

  end

  test "user_feed_recent should be right behave" do
    user2  = create_user_two
    #create a work and tag
    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    timeline =user2.timelines.create(work_id: work.id, act: "new")
    work2 =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    timeline2 =user2.timelines.create(work_id: work2.id, act: "new")

    feeds = user2.user_feed_recent

    assert_equal 2, feeds.count
    assert_equal timeline2.id , feeds.first.id

    feed  = user2.user_feed_recent(1)
    assert_equal 1, feed.count
  end

  test "user_feed should be right behave" do
    user2  = create_user_two
    #create a work and tag
    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    timeline =user2.timelines.create(work_id: work.id, act: "new")

    feeds = user2.user_feed

    assert_equal 1, feeds.count
    assert_equal timeline.id , feeds.first.id
  end

  test "work_feeds_by_fliter should be right behave" do
    user2  = create_user_two
    user3 = create_user_three
    user2.follow(user3)

    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    work2 =user3.works.create!(works_likes_count:1,title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"),created_at: 1.day.ago  )
    work3 =user3.works.create!(thanks_count:1,title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"),created_at: 1.week.ago  )
    work4 =user3.works.create!(repost_count:1,title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"),created_at: 1.month.ago  )
    work5 =user3.works.create!(favorites_count:1,title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"),created_at: 1.year.ago ,is_original:true  )


    #work_feeds_by_fliter(sort = nil,timescope = nil , is_original = false)
    #1. sort work_likes , timecope nil ,is originnal nil
    works = user2.work_feeds_by_fliter("works_likes")
    assert_equal 5, works.count
    assert_equal work2.id, works.first.id

    works2 = user2.work_feeds_by_fliter("thanks")
    assert_equal 5, works2.count
    assert_equal work3.id, works2.first.id

    works3 = user2.work_feeds_by_fliter("repost")
    assert_equal 5, works3.count
    assert_equal work4.id, works3.first.id

    works4 = user2.work_feeds_by_fliter("favorites")
    assert_equal 5, works4.count
    assert_equal work5.id, works4.first.id

    sleep 3

    #timescope
    works5 = user2.work_feeds_by_fliter("works_likes","day")
    assert_equal 1, works5.count
    assert_equal work.id, works5.first.id

    works6 = user2.work_feeds_by_fliter("works_likes","week")
    assert_equal 2, works6.count
    assert_equal work2.id, works6.first.id

    works7 = user2.work_feeds_by_fliter("thanks","month")
    assert_equal 3, works7.count
    assert_equal work3.id, works7.first.id

    works8 = user2.work_feeds_by_fliter("repost","year")
    assert_equal 4, works8.count
    assert_equal work4.id, works8.first.id

    #is_original
    works9 = user2.work_feeds_by_fliter(nil,nil,"true")
    assert_equal 1, works9.count
    assert_equal work5.id, works9.first.id

    #complex
    works10 = user2.work_feeds_by_fliter("favorites",nil,"true")
    assert_equal 1, works10.count
    assert_equal work5.id, works10.first.id

    works11 = user2.work_feeds_by_fliter("favorites","year","true")
    assert_equal 0, works11.count


  end

  test "feed should be right behave" do

    user2  = create_user_two
    user3 = create_user_three
    user2.follow(user3)

    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
    timeline =user2.timelines.create(work_id: work.id, act: "new")

    work2 =user3.works.create!(works_likes_count:1,title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"),created_at: 1.day.ago  )
    timeline2 = user3.timelines.create(work_id: work2.id, act: "new")

    feeds = user2.feed

    assert_equal 2 ,feeds.count
    assert_equal timeline2.id , feeds.first.id

  end

  test "count_total_likes should be right behave" do
    user2  = create_user_two
    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))


    work.works_likes.create!(user_id: 333)

    assert_equal 1,  user2.count_total_likes
  end

  test "count_total_thanks should be right behave" do
    user2  = create_user_two
    work =user2.works.create!(title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))


    work.thanks.create!(user_id: 333)

    assert_equal 1,  user2.count_total_thanks
  end

  test "defalut order should be created_at ASC" do
    user2  = create_user_two
    user3  = create_user_three

    users  = User.where(id: [user2.id, user3.id])
    assert_equal 2, users.count
    assert_equal user2.id , users.first.id

  end
  # test "associated work should be destroyed" do
  #   @user.save
  #   @user.works.create!(image: "/fake.jpg")
  #   assert_difference 'Work.count', -1 do
  #     @user.destroy
  #   end
  # end

  # test "feed should have the right posts" do
  #   michael = users(:michael)
  #   archer = users(:archer)
  #   lana = users(:lana)
  #
  #   lana.microposts.each do |post_following|
  #     assert michael.feed.include?(post_following)
  #   end
  #
  #   michael.microposts.each do |post_self|
  #     assert michael.feed.include?(post_self)
  #   end
  #
  #   archer.microposts.each do |post_unfollowed|
  #     assert_not michael.feed.include?(post_unfollowed)
  #   end
  # end

end
