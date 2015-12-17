class RepostWorkNotify < Notification


  def type_to_s
    "转发了你的作品"
  end

  def obj_id_to_s

    rework =Work.find(obj_id)


    org_work =Work.where(id: rework.parent_work_id).first

    if org_work
      return "<a href='/works/#{rework.id}'>#{org_work.title}</a>".html_safe
    else
      return '[已删除]'
    end
  end

end