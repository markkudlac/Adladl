json.array!(@adverts) do |advert|
  json.extract! advert, :id, :group, :adtype, :filename, :urlhref, :descript
  json.url advert_url(advert, format: :json)
end
