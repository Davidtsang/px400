class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  default_scope {order('created_at DESC')}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :update_icode, :giveme_icodes, :update_role, :welcome_pm

  NICKNAME_REGEX = /\A[\u4e00-\u9fa5_a-zA-Z0-9]+\Z/
  validates :name, length: {maximum: 32, minimum: 2}, presence: true
  validates :title, length: {maximum: 140}
  validates :location, length: {maximum: 80}
  validates :website, length: {maximum: 250}
  validates :company, length: {maximum: 80}

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

  def user_work_recent(limit = 4)
    Work.where(user_id: id).limit(limit)
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

  def welcome_pm

    content = <<-eos

    你好，#{name} !\n
    我是400px.cn CTO兼联合创始人David。 我代表400px及我个人名义，热烈欢迎你应邀加入400px.net设计师社交网络。\n
    400px.cn是中国设计师与艺术家展示作品与交流的平台。你可以在这里展示自己的才华，认识新的朋友，发现创作的灵感。未来我们还将加入职业介绍、人才招聘、作品交易等栏目。打造一个为设计师与艺术家服务的、有品位的垂直社交网络。\n
    目前我们网站还出于公测阶段，难免会有这样那样的不足和缺陷，网络可能也不是非常稳定，希望你能将使用中发现的问题和BUG反馈给我们，我们会及时修正及改进。我们非常欢迎你对我们网站的建设多多提意见。你可以直接发邮件到我的个人邮箱: i.david.tsang@qq.com 。\n
    另外，希望你能多多发表你自己的作品，将你的才华展示给大家。并不仅限完整的作品，400px.cn设计的目的就是让你能展示每天的心得和进步，例如仅仅是一个小的图标、图形、效果、字体，都可以在400px.cn上美观的展示出来。\n
    作为第一批入驻的艺术家，你在本站的角色是高级会员Artist(艺术家)。另外，我们赠送给你10个邀请码，你可以邀请自己的设计师朋友来加入。你可以在 ：会员设置 - 邀请码 选项页面里面看到这些邀请码。\n
    你有什么需求，请及时联系我们。\n
    再次感谢你的加入和支持。让我们一起共同进步！\n
-------------------------\n
    你诚挚的David\n
    400px.cn CTO\n

    eos

    Message.create(from_user_id:2 , :to_user_id => id , content: content, :is_read => false)


  end

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
