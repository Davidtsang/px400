require 'test_helper'

class SiteConfigTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @site_config = SiteConfig.new(the_key: "test", the_value:"1")
  end

  test "should be valid " do

    assert @site_config.valid?

  end

  test "the_key should not repaeat" do
    @site_config.save

    st = SiteConfig.new(the_key: "test", the_value:"1")

    assert_not st.valid?

  end
end
