# encoding: utf-8
FactoryGirl.define do
  factory :indice do
    periodo Time.now.change(sec: 0, min: 0, hour: 0, day: 1).to_date - 1.month
    denominacion 'Costo de construcción'

    # que el indice sea un float
    valor { rand(2000) + rand(99) / 100.0 }
  end
end
