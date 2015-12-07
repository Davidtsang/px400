class RepostWorkNotify < Notification

  def subject_id_to_s
    user = User.find( subject_id)
    "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
  end

  def type_to_s
    "转发了你的作品"
  end

  def obj_id_to_s

    rework =Work.find(obj_id)
    org_work =Work.find rework.parent_work_id

    "<a href='/works/#{rework.id}'>#{org_work.title}</a>".html_safe

  end

end