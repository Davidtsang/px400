module WorksHelper

  def is_liked?(user_id, work_id)
    WorksLike.where(user_id: user_id, work_id: work_id).first

  end

  def arr_slice_to_3(arr)

    each_arr_len = arr.count/3 + 1

    arr1 = arr[1..each_arr_len]
    arr2 = arr[(each_arr_len+1)..each_arr_len*2]
    arr3 = arr[(each_arr_len*2+1)..arr.count]

    return arr1, arr2, arr3

  end

  #<li role="presentation"><a href="<%= url_for(params.merge(sort:"views")) %>">最多浏览的</a></li>
  def sort_name(sort)
    name = "最新的"
    if sort == "views"
      name = "最多人浏览的"
    elsif sort == "comments"
      name = "最多人评论的"
    elsif sort == "works_likes"
      name = "最多人赞的"
    elsif sort == "favorites"
      name = "最多人收藏的"
    elsif sort == "repost"
      name = "最多人Rework的"
    elsif sort == "thanks"
      name = "最多人感谢的"
    end
    name
  end

  def timescope_name(timescope)
    name ="在所有时间段"

    if timescope == "day"
      name = "在过去的一天"
    elsif timescope == "week"
      name = "在过去的一周"
    elsif timescope == "month"
      name = "在过去的一个月"
    elsif timescope == "year"
      name = "在过去的一年"
    end

    name
  end
end
