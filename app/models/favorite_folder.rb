class FavoriteFolder < ActiveRecord::Base
  belongs_to :user
  has_many :favorites

  validates :name , presence: true

end
