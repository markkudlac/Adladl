json.array!(@devices) do |device|
  json.extract! device, :id, :tag, :instruct_cnt
  json.url device_url(device, format: :json)
end
