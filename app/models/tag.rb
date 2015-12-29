class Tag < ActiveRecord::Base

  has_many :users_tags
  has_many :works_tags

  validates :name ,presence: true, length: {minimum: 2, maximum: 40}


  def self.search(search, limit: 12)

      where( "name LIKE ?", "%#{search}%" ).limit(limit)

  end

end
