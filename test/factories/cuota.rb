# encoding: utf-8
FactoryGirl.define do
  factory :cuota do
    contrato_de_venta

    monto_original { Money.new rand(1000) }
    vencimiento { Date.today + rand(30).days}
    descripcion 'cuota de prueba'
  end
end
