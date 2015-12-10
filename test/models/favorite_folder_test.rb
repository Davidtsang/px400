require 'test_helper'

class FavoriteFolderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @favorite_folder = FavoriteFolder.new(user_id: 1, name: "test")
  end

  test "should be valid" do

    assert @favorite_folder.valid?

  end

  test "name should be present" do

    @favorite_folder.name = ""
    assert_not  @favorite_folder.valid?

  end

  test "destroy should be destroy them favorite too " do
    @favorite_folder.save

    fid  = @favorite_folder.id
    Favorite.create!(favorite_folder_id: @favorite_folder.id , work_id: 1)

    @favorite_folder.destroy

    assert_equal 0, Favorite.where(favorite_folder_id: fid  , work_id: 1).count
  end

  # test "scope :recent should be right behave" do
  #   @favorite_folder.save
  #
  #   favorite =Favorite.create!(favorite_folder_id: @favorite_folder.id , work_id: 1)
  #
  #   favorites  = FavoriteFolder.recent(4)
  #   assert_equal 1, favorites.count
  #
  #   assert_equal favorite.id , favorites.first.id
  # end


end
