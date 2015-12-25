class ThanksWorkNotify < Notification



  def type_to_s
    "感谢了你的作品"
  end

  def obj_id_to_s

    work =Work.find(obj_id)

    "<a href='/works/#{work.id}'>#{work.title}</a>".html_safe
  end

  def icon
    '<i class="fa fa-heart"></i>'.html_safe
  end

end