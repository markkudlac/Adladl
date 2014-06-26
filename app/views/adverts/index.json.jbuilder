json.array!(@adverts) do |advert|
  json.extract! advert, :id, :group, :adtype, :ad_filename, :urlhref, :descript, :icon_filename
  json.url advert_url(advert, format: :json)
end
