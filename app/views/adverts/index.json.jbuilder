json.array!(@adverts) do |advert|
  json.extract! advert, :id, :group, :adtype, :urlimg, :urlhref, :descript, :icon
  json.url advert_url(advert, format: :json)
end
