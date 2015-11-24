class FavoriteFolder < ActiveRecord::Base
  belongs_to :user
  has_many :favorites

  validates :name , presence: true

  scope :recent, ->(num) { order('created_at DESC').limit(num) }

   def recent_works(limit= 4)
     Work.joins(:favorites).where("favorites.favorite_folder_id =?", id).order('created_at DESC').limit(limit)

   end

end
