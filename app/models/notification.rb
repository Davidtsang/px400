class Notification < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id

  def self.uncheck_notify_by_user_id(user_id)

    where(user_id: user_id , is_checked: false)

  end

  def subject_id_to_s

  end

  def type_to_s
  end

  def obj_id_to_s

  end
end
