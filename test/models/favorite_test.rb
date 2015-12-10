require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup

    @favorite = Favorite.new(work_id: 1, favorite_folder_id: 1)
  end

  test "should be valid" do

    assert @favorite.valid?

  end

  test "should not repeat work_id" do

    @favorite.save
    favorite = Favorite.new(work_id: 1, favorite_folder_id: 1)

    assert_not favorite.valid?

  end
end
