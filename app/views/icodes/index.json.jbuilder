json.array!(@icodes) do |icode|
  json.extract! icode, :id, :code, :user_id, :is_used, :used_user_id
  json.url icode_url(icode, format: :json)
end
