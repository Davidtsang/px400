require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
     @work =Work.new(user_id: 1, title: "test", image: File.open("#{Rails.root}/public/fake-work.jpg"))
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

  test "title should be present" do
    @work.title = nil
    assert_not @work.valid?
  end

  test "title max 80 should be" do
    @work.title = "t" * 81
    assert_not @work.valid?
  end

  test "title '' should not vaild" do
    @work.title = ""
    assert_not @work.valid?
  end

  test "title ' ' should not vaild" do
    @work.title = " "
    assert_not @work.valid?
  end

  test "descpitcon should be max length < 1000 " do
    @work.desciption= "t" * 1001

    assert_not @work.valid?

  end

  test "destroy work the works_likes should destroy too" do
    @work.save
    @work.works_likes.create!(user_id: 2)

    #should +1 work_likes
    wl =WorksLike.where(work_id:  @work.id , user_id: 2)
    assert_equal 1, wl.count

    @work.destroy

    assert_equal 0 , WorksLike.where(work_id:  @work.id , user_id: 2).count

  end

  test "destroy work the thanks should destroy too" do
    @work.save
    @work.thanks.create!(user_id: 2)

    #should +1 work_likes
    t =Thank.where(work_id:  @work.id , user_id: 2)
    assert_equal 1, t.count

    @work.destroy

    assert_equal 0 , Thank.where(work_id:  @work.id , user_id: 2).count

  end

  test "destroy work the favorites should destroy too" do
    @work.save
    @work.favorites.create!(favorite_folder_id: 2)


    t =Favorite.where(work_id:  @work.id , favorite_folder_id: 2)
    assert_equal 1, t.count

    @work.destroy

    assert_equal 0 , Favorite.where(work_id:  @work.id , favorite_folder_id: 2).count

  end

  test "destroy work the comments should destroy too" do
    @work.save
    @work.comments.create!(user_id: 2, content:"test")


    t =Comment.where(work_id:  @work.id , user_id: 2)
    assert_equal 1, t.count

    @work.destroy

    assert_equal 0 , Comment.where(work_id:  @work.id , user_id: 2).count

  end

  test "destroy work the timelines should destroy too" do
    @work.save
    @work.timelines.create!(user_id: 2)

    t =Timeline.where(work_id:  @work.id , user_id: 2)
    assert_equal 1, t.count

    @work.destroy

    assert_equal 0 , Timeline.where(work_id:  @work.id , user_id: 2).count

  end

  test "destroy work the works_tags should destroy too" do
    @work.save
    @work.works_tags.create!(tag_id: 2)

    t =WorksTag.where(work_id:  @work.id , tag_id: 2)
    assert_equal 1, t.count

    @work.destroy

    assert_equal 0 , WorksTag.where(work_id:  @work.id , tag_id: 2).count

  end

  test "destroy work the all notify should destroy too" do
    @work.save

    #create notify
    RepostWorkNotify.create!(subject_id: 1, obj_id: @work.id,user_id: 1 )
    LikeWorkNotify.create!(subject_id: 1, obj_id: @work.id,user_id: 1 )
    ThanksWorkNotify.create!(subject_id: 1, obj_id: @work.id ,user_id: 1)

    #test
    @work.destroy

    assert_not RepostWorkNotify.where(subject_id: 1, obj_id: @work.id  ).first
    assert_not LikeWorkNotify.where(subject_id: 1, obj_id: @work.id  ).first
    assert_not ThanksWorkNotify.where(subject_id: 1, obj_id: @work.id ).first

  end

end
