module WorksHelper

  def is_liked?(user_id, work_id)
    WorksLike.where(user_id: user_id, work_id: work_id).first

  end
end
