json.array!(@icons) do |icon|
  json.extract! icon, :id, :client_id, :filename, :filesize
  json.url icon_url(icon, format: :json)
end
