json.array!(@icons) do |icon|
  json.extract! icon, :id, :id, :client_id, :filename, :filesize
  json.url icon_url(icon, format: :json)
end
