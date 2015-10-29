class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  NICKNAME_REGEX = /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/

  validates :nickname ,uniqueness: true,:allow_blank=>true, format:{ with: NICKNAME_REGEX , message:"只允许包含中文、英文字母、数字及下划线" }

  has_attached_file :avatar, :styles => {:large=>"200x200#",:normal=>"100x100#", :medium => "50x50#", :mini => "25x25#" }, :default_url => ":style/avatar_missing.png"

  validates_attachment :avatar,
                       :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },size: { in: 0..800.kilobytes }

  has_many :works

  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  # is folloing some user, return ,true
  def following?(other_user)
    following.include?(other_user)
  end
end
