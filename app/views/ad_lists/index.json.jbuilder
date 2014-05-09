json.array!(@ad_lists) do |ad_list|
  json.extract! ad_list, :id, :device_id, :advert_id, :action
  json.url ad_list_url(ad_list, format: :json)
end
