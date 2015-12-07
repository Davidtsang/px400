class SiteConfig < ActiveRecord::Base
  validates :the_key, uniqueness: true

  def self.new_users_icode_num
    where(the_key: __method__).first.the_value
  end

end
