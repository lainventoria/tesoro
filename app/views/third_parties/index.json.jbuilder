json.array!(@third_parties) do |third_party|
  json.extract! third_party, :id, :name, :address, :phone, :cellphone, :email, :tax
  json.url third_party_url(third_party, format: :json)
end
