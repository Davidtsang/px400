require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup

    @tag = Tag.new(name: "test")

  end

  test "should be valid" do

    assert @tag.valid?

  end

  test "Tag.search should be right behave " do
    @tag.save

    t = Tag.search('test')

    assert_equal 'test', t.first.name

  end

end
