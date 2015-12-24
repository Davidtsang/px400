class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  default_scope {order('created_at ASC')}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :update_icode, :giveme_icodes, :update_role

  NICKNAME_REGEX = /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/
  validates :name, length: {maximum: 32, minimum: 2}, presence: true

  #validates_presence_of :name
  validates :nickname, uniqueness: true, :allow_blank => true, format: {with: NICKNAME_REGEX, message: "只允许包含中文、英文字母、数字及下划线"}, length: {maximum: 32, minimum: 2}

  has_attached_file :avatar, :styles => {:large => "200x200#", :normal => "100x100#", :medium => "50x50#", :mini => "25x25#"}, :default_url => ":style/avatar_missing.png"

  validates_attachment :avatar,
                       :content_type => {:content_type => ["image/jpeg", "image/gif", "image/png"]}, size: {in: 0..800.kilobytes}

  #ivite code
  attr_accessor :icode

  validates_each :icode, :on => :create do |record, attr, value|
    value = value.strip if value
    icode  = Icode.where(code: value, is_used: false ).first
    record.errors.add attr, "无效。请输入正确的邀请码。" unless
        value && icode && value == icode.code.to_s
  end

  has_many :works_likes, dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_many :favorite_folders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comments_likes, dependent: :destroy

  has_many :blacklists, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :icodes, dependent: :destroy

  has_many :timelines, dependent: :destroy

  has_many :works, dependent: :destroy
  has_many :recent_works, -> { order('created_at DESC').limit(3) }, class_name: "Work"

  has_many :users_tags, dependent: :destroy

  has_one :icode, foreign_key: "used_user_id"

  has_many :send_messages, class_name: "Message", foreign_key: "from_user_id", dependent: :destroy

  has_many :receive_messages, ->{ receive_default },class_name: "Message", foreign_key: "to_user_id", dependent: :destroy

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
    active_relationships.create(followed_id: other_user.id) unless other_user.id == id
  end

  def is_admin?

    if user_role == "admin"
       return true
    else
      return false
    end

  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # is folloing some user, return ,true
  def following?(other_user)
    following.include?(other_user)
  end

  #get all user by skill id

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

  def work_feeds_by_fliter(sort = nil,timescope = nil , is_original = false)
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
         is_original_where = "works.is_original = 't' "
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

  def count_total_likes
    Work.sum(:works_likes_count, :conditions => {:user_id => id})
  end

  def count_total_thanks
    Work.sum(:thanks_count, :conditions => {user_id: id})
  end

  def self.send_daily_notice_email

    @users = User.where(:is_allow_notice_mail => true)

    @users.each do |user|
      new_notice_count = Notification.where(:user_id => user.id , :is_checked => false).count
      new_pm_count = Message.where(:to_user_id => user.id, :is_read => false).count


      if new_notice_count > 0 || new_pm_count > 0


          UserMailer.daily_notice_email(user, new_notice_count, new_pm_count).deliver_now

      end

    end
  end

  private

  def update_role
    if id == 1
      self.user_role= "admin"

    else
      self.user_role= "artist"

    end
    #puts '----:)'
    #puts self.user_role
    self.save

  end

  def update_icode

    if self.icode
      self.icode = self.icode.strip

      used_code =Icode.where(code: icode).first
      used_code.used_user_id = id
      used_code.is_used= true
      used_code.save
      #puts '----:)'
      #puts used_code.is_used
    end

  end

  def giveme_icodes
    #get site settings
    give_number = SiteConfig.new_users_icode_num.to_i
    give_number.times do
      icode =Icode.new
      icode.generate_code
      icode.user_id = id
      icode.save
    end
  end

end
