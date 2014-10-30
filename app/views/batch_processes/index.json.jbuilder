json.array!(@batch_processes) do |batch_process|
  json.extract! batch_process, :id, :name
  json.url batch_process_url(batch_process, format: :json)
end
