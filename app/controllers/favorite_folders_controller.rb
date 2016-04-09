class FavoriteFoldersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  before_action :set_favorite_folder, only: [:edit, :show, :update, :destroy]

  before_action :this_auth_block_user, only: [:create_favorite]

  def new
    @work_id = params[:work_id]
    @favorite_folder = FavoriteFolder.new

    respond_to do |format|
      format.js

    end
  end

  def create
    @work_id = params[:work_id]
    @favorite_folder = current_user.favorite_folders.create(favorite_folders_params)

    #notify author

    respond_to do |format|
      @favorite_folders = current_user.favorite_folders.all
      format.js
    end

  end

  #ajsx get user ff
  def index
    @work_id = params[:work_id]

    @favorite_folders = current_user.favorite_folders.all


    respond_to do |format|
      format.html
      format.js
    end

  end

  def show

  end

  def edit

  end

  def update

    @favorite_folder.update(favorite_folders_params)

    respond_to do |format|
      format.html {
        flash[:notice] = "文件夹已经成功更新."
        redirect_to favorite_folder_path @favorite_folder }
    end
  end

  def destroy

    @favorite_folder.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = "文件夹#{@favorite_folder.name}已经成功删除."
        redirect_to favorite_folders_path }
    end
  end

  #create_favorite

  #add a work to favorite folder
  def create_favorite
    id = params[:favorite_folder_id]
    @work_id = params[:work_id]

    favorite = Favorite.create(work_id: @work_id, favorite_folder_id: id)
    work = Work.find(@work_id)

    FavoriteWorkNotify.create(subject_id: current_user.id, obj_id: favorite.id, user_id: work.user_id)

    respond_to do |format|
      @favorite_folders = current_user.favorite_folders.all
      format.js
    end

  end

  #delete
  def delete_favorite
    id = params[:id]
    @work_id = params[:work_id]

    favorite = Favorite.where(favorite_folder_id: id, work_id: @work_id).first

    #first del notify
    FavoriteWorkNotify.where(subject_id: current_user.id, obj_id: favorite.id).destroy_all

    favorite.destroy

    respond_to do |format|
      @favorite_folders = current_user.favorite_folders.all
      format.js
    end

  end

  private

  def this_auth_block_user
    work_id = params[:work_id]
    @work = Work.find(work_id)
    auth_block_user!

  end

  def set_favorite_folder
    @favorite_folder = FavoriteFolder.find(params[:id])
  end

  def favorite_folders_params
    params.require(:favorite_folder).permit(:name)
  end
end
