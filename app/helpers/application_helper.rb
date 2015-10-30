module ApplicationHelper
  def current_user?(user)
    result = false
    if current_user.id == user.id
      result = true
    end
    return result
  end
end
