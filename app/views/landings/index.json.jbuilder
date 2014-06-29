json.array!(@landings) do |landing|
  json.extract! landing, :id, :client_id, :zipname, :filesize
  json.url icon_url(icon, format: :json)
end
