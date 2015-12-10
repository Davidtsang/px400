require 'test_helper'

class IcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @icode = Icode.new(code: Icode.generate_code , user_id: 1)
  end

  test "should be valid " do

    assert @icode.valid?

  end


  test "code should be present" do
    @icode.code = nil

    assert_not @icode.valid?

  end

  test "generate_code should be right behave" do

    code = @icode.generate_code

    assert code

  end
end
