class Tag < ActiveRecord::Base

  has_many :users_tags

  def self.search(search)

      where( "name LIKE ?", "%#{search}%" )

  end

end
