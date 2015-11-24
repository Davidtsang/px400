class FavoriteFoldersController < ApplicationController

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

    respond_to do |format|
      format.js { redirect_to favorite_folders_path(work_id: @work_id), format: "js" }
    end

  end

  #ajsx get user ff
  def index
    @work_id = params[:work_id]

    @favorite_folders = current_user.favorite_folders.all
    #check
    ff_ids = @favorite_folders.map(&:id)
    @favorites ={}

    favorites = Favorite.where(work_id: @work_id, favorite_folder_id: ff_ids)

    if favorites
      favorites.each do |f|
        @favorites[f.favorite_folder_id]= f
      end
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
    @favorite_folder = FavoriteFolder.find(params[:id])
  end

  def edit
    @favorite_folder = FavoriteFolder.find(params[:id])
  end

  def update
    @favorite_folder = FavoriteFolder.find(params[:id])
    @favorite_folder.update(favorite_folders_params)

    respond_to do |format|
      format.html {
        flash[:notice] = "文件夹已经成功更新."
        redirect_to favorite_folder_path @favorite_folder }
    end
  end

  def destroy
    @favorite_folder = FavoriteFolder.find(params[:id])
    @favorite_folder.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = "文件夹#{@favorite_folder.name}已经成功删除."
        redirect_to favorite_folders_path  }
    end
  end
  #create_favorite
  #add a work to favorite folder
  def create_favorite
    id = params[:favorite_folder_id]
    @work_id = params[:work_id]

    Favorite.create(work_id: @work_id, favorite_folder_id: id)

    respond_to do |format|
      format.js { redirect_to favorite_folders_path(work_id: @work_id), format: "js" }
    end

  end

  #delete
  def delete_favorite
    id = params[:id]
    @work_id = params[:work_id]

    f = Favorite.find(id)
    f.destroy


    respond_to do |format|
      format.js { redirect_to favorite_folders_path(work_id: @work_id), format: "js" }
    end

  end

  private

  def favorite_folders_params
    params.require(:favorite_folder).permit(:name)
  end
end
