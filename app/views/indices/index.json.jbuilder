json.array!(@indices) do |indice|
  json.extract! indice, :id, :denominacion, :periodo, :valor
  json.url indice_url(indice, format: :json)
end
