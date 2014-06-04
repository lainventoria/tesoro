# encoding: utf-8
FactoryGirl.define do
  factory :cuota do
    contrato_de_venta

    monto_original { Money.new rand(1000) }
    vencimiento { Time.now + rand(360000) }
    descripcion "cuota de prueba"
  end
end

