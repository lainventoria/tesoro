# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recibo do
    fecha "2014-01-17 21:25:25"
    importe ""
    emitido false
    recibido false
    factura nil
  end
end
