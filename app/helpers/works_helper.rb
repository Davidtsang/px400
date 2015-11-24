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

end
