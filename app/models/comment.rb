class Comment < ActiveRecord::Base
  belongs_to :work , :counter_cache => true
  belongs_to :user

  validates :content ,presence: true

  has_many :comments_likes

end
