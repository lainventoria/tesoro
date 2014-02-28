# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cheque do
    cuenta

    monto { Money.new rand(1000) }
    fecha { Time.now }
    fecha_vencimiento { Time.now + rand(360000) }
  end
end
