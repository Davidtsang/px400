class LikeWorkNotify < Notification

  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "赞了你的作品"
  end

  def obj_id_to_s

    work =Work.find(obj_id)

    "<a href='/works/#{work.id}'>#{work.title}</a>".html_safe
  end

  def icon
    '<i class="fa fa-thumbs-up"></i>'.html_safe
  end

end