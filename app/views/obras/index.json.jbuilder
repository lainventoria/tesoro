json.array!(@obras) do |obra|
  json.extract! obra, :id, :nombre
  json.url obra_url(obra, format: :json)
end
