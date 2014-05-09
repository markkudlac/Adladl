json.array!(@devices) do |device|
  json.extract! device, :id, :tag
  json.url device_url(device, format: :json)
end
