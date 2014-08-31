# encoding: utf-8
require 'test_helper'

class IndiceTest < ActiveSupport::TestCase
  test 'es válido' do
    [:build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :indice
    end
  end

  test 'necesita un periodo' do
    refute build(:indice, periodo: nil).save
  end

  test 'necesita una denominacion' do
    refute build(:indice, denominacion: nil).save
  end

  test 'necesita un valor' do
    refute build(:indice, valor: nil).save
  end

  test 'mpj esta feliz, los indices vienen como deben' do
    denominacion = Indice::DENOMINACIONES.sample
    periodo = (Date.today - rand(10).months).beginning_of_month
    i = create(:indice, denominacion: denominacion, periodo: periodo)
    i2 = Indice::por_fecha_y_denominacion(periodo + rand(25).days, denominacion)

    assert i2 == i, [periodo, denominacion, i, i2]
  end
end
