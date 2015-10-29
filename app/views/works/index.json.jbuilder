json.array!(@works) do |work|
  json.extract! work, :id, :title, :image, :desciption, :user_id, :views_count, :likes_count, :favorites_count, :shares_count
  json.url work_url(work, format: :json)
end
