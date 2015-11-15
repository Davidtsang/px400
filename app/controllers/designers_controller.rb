class DesignersController < ApplicationController
  def all
    if params[:domain_id]
      @designers =User.where("(domain_1_id  =? ) OR ( domain_2_id =?) ",params[:domain_id],params[:domain_id]).paginate(page: params[:page])
    else
      @designers = User.paginate(page: params[:page])
    end


    @designers
  end

  def show
    @user = User.find(params[:id])
    #@works = @user.works.paginate(page: params[:page])
    @feed_items = @user.user_feed.paginate(page: params[:page])
  end

  def show_tag
    @user = User.find(params[:id])
    #@works = @user.works.paginate(page: params[:page])
    @tag  = Tag.find(params[:tag_id])
    @feed_items = @user.user_feed_by_tag_id(params[:tag_id]).paginate(page: params[:page])
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @designers = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @designers = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def block_user

    current_user.blacklists.create(block_user_id: params[:block_user_id])

    @user = User.find(params[:block_user_id])
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
