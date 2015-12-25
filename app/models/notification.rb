class Notification < ActiveRecord::Base
  belongs_to :user

  default_scope {order('created_at DESC')}
  validates_presence_of :user_id

  def self.uncheck_notify_by_user_id(user_id)

    where(user_id: user_id, is_checked: false)

  end

  def subject_id_to_s
    user = User.where(id: subject_id).first
    if user
      return "<a href='/designers/#{user.id}'>#{user.name}</a>".html_safe
    else

      return  '[已删除]'

    end
  end

  def type_to_s
  end

  def icon
    ""
  end

  def obj_id_to_s

  end
end
