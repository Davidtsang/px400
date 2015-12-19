class Work < ActiveRecord::Base
  after_destroy :destroy_notifys
  belongs_to :user
  validates :user_id, presence: true
  validates :image ,presence: true
  validates :title ,presence: true, length: {minimum: 1, maximum: 80 }

  validates :desciption, length: {maximum: 1000}

  default_scope -> { order(created_at: :desc) }

  has_attached_file :image, :styles => {:original=> "800x600#",:sd=>"400x300#", :small => "200x150#"}

  validates_attachment :image,
                       :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },size: { in: 0..5000.kilobytes }

  has_many :works_likes, dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :timelines , dependent: :destroy
  has_many :works_tags , dependent: :destroy



  def self.count_user_total_likes(user_id)
    where(:user_id => user_id).sum(:works_likes_count )
  end

  def self.count_user_total_thanks(user_id)
    where(:user_id => user_id).sum(:thanks_count )
  end

  private

  def destroy_notifys
    RepostWorkNotify.destroy_all(obj_id: id  )
    LikeWorkNotify.destroy_all(obj_id: id  )
    ThanksWorkNotify.destroy_all(obj_id: id  )
  end
end
