# encoding: utf-8
FactoryGirl.define do
  factory :contrato_de_venta do
    tercero
    indice
    obra

    fecha { Time.now }

    monto_total { Money.new (10000000 + rand(1000)) }
  end
end

