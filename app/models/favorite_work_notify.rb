class FavoriteWorkNotify < Notification

  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "收藏了你的作品"
  end

  def obj_id_to_s

    favorite =Favorite.find(obj_id)
    folder = favorite.favorite_folder
    work = Work.find(favorite.work_id)
    "<a href='/favorite_folders/#{folder.id}'>#{work.title}</a>".html_safe
  end

  def icon
    
    '<i class="fa fa-star"></i>'.html_safe
    
  end
end