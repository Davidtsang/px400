class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :this_auth_block_user, only: [:create]

  def create

    current_user.follow(@user)

    #notify user
    FollowingNotify.create(subject_id: current_user.id, obj_id: @user.id  , user_id: @user.id)

    respond_to do |format|
      format.html { redirect_to designers_all_path }
      format.js
    end
  end

  def destroy


    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    #un notify user
    notify =FollowingNotify.where(subject_id: current_user.id, obj_id: @user.id).first
    notify.destroy if notify

    respond_to do |format|
      format.html { redirect_to designers_all_path }
      format.js
    end
  end

  private

  def this_auth_block_user

    @user = User.find(params[:followed_id])
    auth_block_user!

  end
end
