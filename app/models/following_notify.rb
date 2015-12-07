class FollowingNotify < Notification

  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "关注了你"
  end

  def obj_id_to_s
    ""
  end

end