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
    @feed_items = @user.feed.paginate(page: params[:page])
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


end
