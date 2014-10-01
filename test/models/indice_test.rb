# encoding: utf-8
require 'test_helper'

class IndiceTest < ActiveSupport::TestCase
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

  test 'al tener muchos temporales, hay que reindexar las cuotas al ir actualizándolos' do
    cv = create :contrato_de_venta
    5.times do |t|
      cv.agregar_cuota(attributes_for(:cuota).merge({
        monto_original: cv.monto_total / 5,
        vencimiento: Date.today + t.months
      }))
    end

    # generar todos los indices temporales
    cv.cuotas.each do |cuota|
      cuota.monto_actualizado
    end

    # generar una factura que se va a ir actualizando
    cv.cuotas.last.generar_factura
    monto_factura = cv.cuotas.last.factura.importe_total

    cv.cuotas[2].indice.update!(valor: cv.cuotas[2].indice.valor * 2)

    assert_equal cv.cuotas[2].indice.valor, cv.cuotas.last.reload.indice.valor
    assert_not_equal monto_factura, cv.cuotas.last.factura.importe_total
    # sigue siendo temporal
    assert cv.cuotas.last.indice.temporal?
  end
end
