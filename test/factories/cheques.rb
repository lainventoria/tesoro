# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cheque do
    cuenta
    recibo

    beneficiario "pepe honguito"
    monto { Money.new rand(10) }
    fecha_emision { Time.now }
    fecha_vencimiento { Time.now + rand(360000) }
  end
end
