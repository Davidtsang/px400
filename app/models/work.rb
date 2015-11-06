class Work < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :image ,presence: true
  validates :title ,presence: true

  default_scope -> { order(created_at: :desc) }

  has_attached_file :image, :styles => {:hd=>"800x600#",:sd=>"400x300#", :small => "200x150#"}

  validates_attachment :image,
                       :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },size: { in: 0..3000.kilobytes }

  has_many :works_likes
  has_many :thanks
  has_many :favorites
  has_many :comments

end
