class CommentsWorkNotify < Notification

  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "评论了你的作品"
  end

  def obj_id_to_s

    comment =Comment.find(obj_id)
    work = comment.work

    "<a href='/works/#{work.id}#comment_#{comment.id}'>#{work.title}</a>".html_safe
  end

  def icon
    '<i class="fa fa-commenting"></i>'.html_safe
  end
end