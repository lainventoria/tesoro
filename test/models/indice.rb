# encoding: utf-8
require 'test_helper'

class IndiceTest < ActiveSupport::TestCase
  test "es válido" do
    [ :build, :build_stubbed, :create ].each do |metodo|
      assert_valid_factory metodo, :indice
    end
  end

  test "necesita un periodo" do
    assert i = build(:indice, periodo: nil)
    assert_not i.save
  end

  test "necesita una denominacion" do
    assert i = build(:indice, denominacion: nil)
    assert_not i.save
  end

  test "necesita un valor" do
    assert i = build(:indice, valor: nil)
    assert_not i.save
  end

  test "mpj esta feliz" do
    denominacion = DENOMINACIONES.sample
    periodo = Time.now.change(sec: 0, min: 0, hour: 0, day: 1).to_date - rand(10).month 
    assert i = build(:indice, denominacion: denominacion, periodo: periodo)
    assert i2 = por_fecha_y_denominacion(periodo + rand(25).day, denominacion)
    assert i2 == i
  end
end
