# encoding: utf-8
require 'test_helper'

class ContratoDeVentaTest < ActiveSupport::TestCase
  test 'es válido' do
    # FIXME build_stubbed falla con la creación de unidades_funcionales
    [:build, :create].each do |metodo|
      assert_valid_factory metodo, :contrato_de_venta
    end
  end

  test 'el contrato tiene un pago inicial' do
    cv = create(:contrato_de_venta)

    cv.agregar_pago_inicial(cv.fecha, Money.new(1000 * 100))
    assert_equal 'Pago inicial', cv.cuotas.first.descripcion
    assert_equal Money.new(1000 * 100), cv.cuotas.first.monto_original
  end

  test 'el contrato tiene cuotas' do
    cv = create(:contrato_de_venta)

    # 10% del monto total
    pi = cv.monto_total * 0.1

    cv.agregar_pago_inicial(cv.fecha, pi)
    cv.agregar_cuota(attributes_for(:cuota))
    cv.agregar_cuota(attributes_for(:cuota))
    cv.agregar_cuota(attributes_for(:cuota))
    cv.agregar_cuota(attributes_for(:cuota))

    assert_equal 5, cv.cuotas.count

  end

  test 'el monto original es la suma de las unidades funcionales' do
    cv = create(:contrato_de_venta)

    # el factory siempre agrega una
    total = cv.unidades_funcionales.first.precio_venta

    5.times do
      uf = create :unidad_funcional
      total += uf.precio_venta
      cv.agregar_unidad_funcional(uf)
    end

    assert_equal total, cv.monto_total
  end

  test 'el tercero debe ser un cliente' do
    assert build(:contrato_de_venta, tercero: create(:proveedor)).invalid?
  end

  test 'las unidades de venta se venden en la misma moneda' do
    cv = create(:contrato_de_venta)
    uf_usd = create(:unidad_funcional, precio_venta_final: Money.new(1000, 'USD'))

    cv.agregar_unidad_funcional(uf_usd)
    refute cv.valid?, cv.inspect
  end

  test '#periodo_para da el mes actual para el indice actual' do
    fecha = DateTime.now

    assert_equal fecha.beginning_of_month,
      build(:contrato_de_venta, relacion_indice: 'actual').periodo_para(fecha)
  end

  test '#periodo_para da el mes anterior para el indice anterior' do
    fecha = DateTime.now

    assert_equal fecha.last_month.beginning_of_month,
      build(:contrato_de_venta, relacion_indice: 'anterior').periodo_para(fecha)
  end

  test 'normaliza el tipo de la factura' do
    cv = build :contrato_de_venta

    cv.tipo_factura = '     abc___'
    assert_equal 'A', cv.tipo_factura
  end
end
