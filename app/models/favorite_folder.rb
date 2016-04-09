class FavoriteFolder < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, :dependent => :destroy

  validates :name, presence: true

  #scope :recent, ->(num) { order('created_at DESC').limit(num) }

  def recent_works(limit= 4)
    Work.joins(:favorites).where("favorites.favorite_folder_id =?", id).order('created_at DESC').limit(limit)

  end

  def is_favorite_work?(work_id)
    result = false
    favorite  = Favorite.where(work_id: work_id, favorite_folder_id: id).first
    if favorite
      result = true
    end

    result
  end

end
