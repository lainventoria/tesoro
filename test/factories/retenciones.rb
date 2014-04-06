# encoding: utf-8
FactoryGirl.define do
  factory :retencion do
    monto { Money.new(rand(100)) }
    fecha_vencimiento { Date.tomorrow }
    chequera
    factura

    # Un documento válido
    documento_file_name     'fake.pdf'
    documento_content_type  'application/pdf'
    documento_file_size     1024
    documento_updated_at    '2014-04-06T04:24:29-03:00'
  end
end
