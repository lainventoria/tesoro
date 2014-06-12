json.array!(@unidades) do |unidad|
  json.extract! unidad, :id, :obra_id
  json.url unidad_funcional_url(unidad, format: :json)
end
