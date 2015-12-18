class DesignersController < ApplicationController
  before_action :authenticate_user!, only: [:block_user, :unblock_user, :followers, :following]

  def all
    @domain_id = params[:domain_id]
    #@current_user = current_user
    @skill_id = params[:skill_id]


    # 1.  no domain id
    # 2.  domain id = -1
    @skills = []
    #domian_id = nil #user defult scope
    if @domain_id == nil
      if current_user
        @domain_id = current_user.domain_1_id
        @designers =User.all_by_domain_id_and_skill_id(@domain_id, @skill_id).paginate(page: params[:page])
        @skills = Skill.all_by_users_domain_id(@domain_id) unless @skill_id

      else
        @designers = User.paginate(page: params[:page])
        @skills = Skill.order("items_count DESC").limit(100)
      end
    elsif @domain_id.to_i == -1 #domian_id = -1#force all scope
      unless @skill_id
        @designers = User.paginate(page: params[:page])
        @skills = Skill.order("items_count DESC").limit(100)
      else
        @designers = User.all_by_skill_id(@skill_id).paginate(page: params[:page])
      end

    else #domian_id  and domain_id != -1 # some domain sope
      @designers =User.all_by_domain_id_and_skill_id(@domain_id, @skill_id).paginate(page: params[:page])

      @skills = Skill.all_by_users_domain_id(@domain_id) unless @skill_id

    end

    if  current_user && !current_user.domain_1_id
      flash[:alert] =  "你没有设置你的第一领域！这导致一些功能无法使用。点击<a href='/profile' data-no-turbolink='true'>这里</a>去设置。".html_safe
    end

  end

  def show
    @user = User.find(params[:id])

    @total_likes = Work.count_user_total_likes @user.id
    @total_thanks = Work.count_user_total_thanks @user.id

    @feed_items = @user.user_feed.paginate(page: params[:page])
  end

  def show_tag
    @user = User.find(params[:id])
    #@works = @user.works.paginate(page: params[:page])
    @tag = Tag.find(params[:tag_id])
    @feed_items = @user.user_feed_by_tag_id(params[:tag_id]).paginate(page: params[:page])
  end

  def following
    @title = "关注的人"
    @user = User.find(params[:id])
    @designers = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "的粉丝"
    @user = User.find(params[:id])
    @designers = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def block_user

    #current_user.blacklists.create(block_user_id: params[:block_user_id])

    @user = User.find(params[:block_user_id])

    Blacklist.block_user(current_user, @user)

    respond_to do |format|

      format.js
    end
  end

  def unblock_user

    bu =current_user.blacklists.where(block_user_id: params[:block_user_id]).first

    bu.destroy

    @user = User.find(params[:block_user_id])
    respond_to do |format|
      format.js
    end
  end

end
