# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tercero do
    nombre "MyString"
    cuit "20-24229800-5"
    contacto "MyString"
    telefono "MyString"
    celular "MyString"
    email "MyString"
    iva { rand(50) }
    cliente_o_proveedor "MyString"
    direccion "MyString"
    notas "MyText"
  end
end
