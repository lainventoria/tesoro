# encoding: utf-8
FactoryGirl.define do
  factory :contrato_de_venta do
    tercero
    indice

    fecha { Time.now }

    # que el indice sea un float
    monto_total { rand(2000) + rand(99) / 100.0 }
    indice_base { indice.indice }
  end
end

