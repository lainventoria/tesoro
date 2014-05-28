# encoding: utf-8
FactoryGirl.define do
  factory :indice do
    periodo '2013-01-01'
    denominacion 'Costo de Construcción'

    # que el indice sea un float
    indice { rand(2000) + rand(99) / 100.0 }
  end
end
