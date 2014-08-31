# encoding: utf-8
FactoryGirl.define do
  factory :indice do
    periodo { Date.today - (rand(12) + 1).month }
    denominacion { Indice::DENOMINACIONES.sample }

    # que el indice sea un float
    valor { rand(2000) + rand(99) / 100.0 }

    factory :indice_cuota do
      denominacion 'Costo de construcción'
    end
  end
end
