# encoding: utf-8
require 'test_helper'

class ObrasGenerarFacturasTest < ActiveSupport::TestCase
  # creamos varios contratos para una obra con todas sus cuotas vencidas
  setup do
    @obra = create :obra
    @tercero = create :tercero
    @indice = create :indice, denominacion: 'Costo de construcción', periodo: (Date.today - 1.year).beginning_of_month

    5.times do
      cv = create :contrato_de_venta, obra: @obra, tercero: @tercero, fecha: (Date.today - 11.months).beginning_of_month
      cv.agregar_unidad_funcional(create :unidad_funcional, obra: @obra)
      cv.agregar_pago_inicial(cv.fecha, cv.monto_total * 0.2)

      cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: cv.monto_total * 0.2, vencimiento: cv.fecha - 1.months}))
      cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: cv.monto_total * 0.2, vencimiento: cv.fecha - 2.months}))
      cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: cv.monto_total * 0.2, vencimiento: cv.fecha - 3.months}))
      cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: cv.monto_total * 0.2, vencimiento: cv.fecha - 4.months}))
    end
  end

  test "crear todas las facturas que hagan falta" do
    assert_equal 0, @obra.facturas.count
    assert @obra.generar_facturas_para_cuotas_vencidas
    assert_equal Cuota.vencidas.count, @obra.facturas.count
  end

end
