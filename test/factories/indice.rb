# encoding: utf-8
FactoryGirl.define do
  factory :indice do
    periodo '2013-01-01'
    denominacion 'Costo de construcción'

    # que el indice sea un float
    valor { rand(2000) + rand(99) / 100.0 }
  end
end
