# encoding: utf-8
FactoryGirl.define do
  factory :contrato_de_venta do
    tercero
    indice
    obra

    fecha { Time.now }

    monto_total { Money.new (10000000 + rand(1000)) }

    # los contratos de venta no tienen sentido sin unidades funcionales
    # asignadas
    # http://stackoverflow.com/questions/13851382/factorygirl-has-many-association-with-validation
    # FIXME no funciona con :build_stubbed
    after(:build) do |factory, evaluator|
      factory.agregar_unidad_funcional(FactoryGirl.build(:unidad_funcional))
    end
  end
end

