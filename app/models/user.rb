class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  NICKNAME_REGEX = /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/

  validates :nickname, uniqueness: true, :allow_blank => true, format: {with: NICKNAME_REGEX, message: "只允许包含中文、英文字母、数字及下划线"}

  has_attached_file :avatar, :styles => {:large => "200x200#", :normal => "100x100#", :medium => "50x50#", :mini => "25x25#"}, :default_url => ":style/avatar_missing.png"

  validates_attachment :avatar,
                       :content_type => {:content_type => ["image/jpeg", "image/gif", "image/png"]}, size: {in: 0..800.kilobytes}

  #ivite code
  attr_accessor :icode

  validates_each :icode, :on => :create do |record, attr, value|
    record.errors.add attr, "无效。请输入正确的邀请码。" unless
        value && value == Icode.where(code: value).first.to_s
  end

  has_many :works_likes
  has_many :thanks
  has_many :favorite_folders
  has_many :comments
  has_many :comments_likes

  has_many :blacklists

  has_many :notifications
  has_many :icodes

  has_many :timelines, dependent: :destroy

  has_many :works, dependent: :destroy
  has_many :recent_works, -> { order('created_at DESC').limit(3) }, class_name: "Work"

  has_many :users_tags

  has_many :send_messages, class_name: "Message", foreign_key: "from_user_id", dependent: :destroy

  has_many :receive_messages, ->{ receive_default},class_name: "Message", foreign_key: "to_user_id", dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower


  def blocked?(user_id)
    blacklists.where(block_user_id: user_id).any?

  end

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

  def self.all_by_skill_id(skill_id)
    joins("JOIN users_tags ON users_tags.user_id = users.id").where("users_tags.tag_id = :skill_id  ", skill_id: skill_id)
  end

  def self.all_by_domain_id_and_skill_id(domain_id ,skill_id=nil)

      unless skill_id
        where("(domain_1_id = :domain_id OR domain_2_id = :domain_id)",domain_id: domain_id)
      else
        joins("JOIN users_tags ON users_tags.user_id = users.id").where("users_tags.tag_id = :skill_id AND (users.domain_1_id = :domain_id OR users.domain_2_id = :domain_id) ", skill_id: skill_id, domain_id: domain_id)
      end

  end

  def user_feed_by_tag_id(tag_id)
    #find user feed : 1 feeduser id = user _id , feed's work_id in works_tag work_id ==
    #and work_tag tag id = tag_id
    Timeline.joins("JOIN works ON timelines.work_id = works.id").joins("JOIN works_tags   ON works.id = works_tags.work_id").where("timelines.user_id = :user_id AND works_tags.tag_id = :tag_id", {user_id: id , tag_id: tag_id})

  end

  def user_feed_recent(limit = 4)
    Timeline.includes(:work).where("user_id = :user_id", user_id: id).order('created_at DESC').limit(limit)
  end

  def user_feed
    Timeline.includes(:work).where("user_id = :user_id", user_id: id).order('created_at DESC')
  end

  def work_feed_by_fliter(sort = nil,timescope = nil , is_original = false)
    sort_order ="created_at DESC"
    timescope_where =""
    is_original_where =""

    #sort
    if sort && sort != ""
        sort_order = "works.#{sort}_count DESC"
    end

    #time
    if timescope
      if timescope == "week"
        time_start = 1.week.ago.to_s(:db)
      elsif timescope =="day"
        time_start = 1.day.ago.to_s(:db)
      elsif timescope =="year"
        time_start = 1.year.ago.to_s(:db)
      elsif timescope == "month"
        time_start = 1.month.ago.to_s(:db)
      end

      timescope_where = "works.created_at > '#{time_start}' "
    end

    #is original
    if is_original == "true"
         is_original_where = "works.is_original == 't' "
    end
    following_ids = "SELECT followed_id FROM relationships
WHERE follower_id = :user_id"
    Work.unscoped.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).where(timescope_where).where(is_original_where).order(sort_order)

  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
WHERE follower_id = :user_id"
    Timeline.includes(:work).where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).order('created_at DESC')
  end
end
