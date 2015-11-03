class DesignersController < ApplicationController
  def all
    @designers = User.paginate(page: params[:page])

  end

  def show
    @user = User.find(params[:id])
    @works = @user.works.paginate(page: params[:page])
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
