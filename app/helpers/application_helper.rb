module ApplicationHelper
  def current_user?(user_id)
    result = false

    if current_user.id == user_id
      result = true
    end
    return result
  end

  def uncheck_notify_count
    result = ""
    if current_user
      notifys = Notification.uncheck_notify_by_user_id(current_user.id)
      if notifys.count > 0
        result ="<span class='badge'>#{notifys.count}</span>"
      end
    end
    result
  end

  def pm_count
    result = ""


    messages = Message.where(is_read: false , to_user_id: current_user.id ).count

    if messages > 0
      result ="<span class='badge'>#{messages}</span>".html_safe
    end
    result
  end


end
