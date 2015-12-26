class ReplyCommentNotify < Notification


  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "回复了你在"
  end

  def obj_id_to_s

    comment =Comment.find(obj_id)
    work = comment.work

    "<a href='/works/#{work.id}#comment_#{comment.id}'>#{work.title}</a> 的评论".html_safe
  end

  def icon
    '<i class="fa fa-reply"></i>'.html_safe
  end
end