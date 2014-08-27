# encoding: utf-8
require 'test_helper'

class CuotaTest < ActiveSupport::TestCase

  setup do
    @cv = create(:contrato_de_venta, fecha: Date.today - 2.months)

    indice_viejo = create(:indice_cuota, periodo: (Date.today - 10.months).beginning_of_month)
    indice_viejo.save

    @indice = @cv.indice_para(Date.today - 2.months)
    @cv.indice = @indice

    @cv.agregar_pago_inicial(@cv.fecha, @cv.monto_total * 0.2)

    assert @cv.monto_total * 0.2 > 0, [@cv.monto_total, @cv.inspect, @cv.unidades_funcionales.inspect]

    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.2, vencimiento: Date.today - 1.months}))
    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.2, vencimiento: Date.today - 1.days}))
    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.1, vencimiento: Date.today + 1.months}))
    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.1, vencimiento: Date.today + 2.months}))
    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.1, vencimiento: Date.today + 3.months}))
    @cv.agregar_cuota(attributes_for(:cuota).merge({monto_original: @cv.monto_total * 0.1, vencimiento: Date.today + 4.months}))

    @cv.save
  end

  test 'es válida' do
    [ :build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :cuota
    end
  end

  test 'necesita monto_original' do
    m = build(:cuota, monto_original_centavos: nil)
    refute m.save
  end

  test 'necesita vencimiento' do
    m = build(:cuota, vencimiento: nil)
    refute m.save
  end

  test 'necesita descripcion' do
    m = build(:cuota, descripcion: nil)
    refute m.save
  end

  test 'el monto se actualiza en base al indice del mes anterior' do
    cuota = @cv.cuotas.sin_vencer.sample
    indice_siguiente = create(:indice_cuota, valor: 1200, periodo: @cv.periodo_para(cuota.vencimiento))

    assert_equal indice_siguiente, cuota.indice_actual
    assert_equal cuota.monto_original * (indice_siguiente.valor / @indice.valor), cuota.monto_actualizado
  end

  test 'listar cuotas vencidas' do
    assert_equal 2, @cv.cuotas.vencidas.count, @cv.cuotas.vencidas.inspect
  end

  test 'algunas cuotas están vencidas' do
    assert @cv.cuotas.vencidas.first.vencida?, @cv.cuotas.vencidas.inspect
  end

  test 'las cuotas generan facturas de cobro' do
    c = @cv.cuotas.first
    c.generar_factura

    f = Factura.last

    assert_equal c.factura, f
    assert f.cobro?
    assert_equal c.monto_actualizado, f.importe_neto
    assert_equal c.tercero, f.tercero
    assert_equal c.obra, f.obra
    assert_equal c.contrato_de_venta.tipo_factura, f.tipo
    assert_equal c.vencimiento + 10.days, f.fecha_pago.to_date
  end

  test 'las cuotas que no están vencidas se pagan al indice actual' do
    c = @cv.cuotas.sin_vencer.pendientes.sample
    refute c.vencida?, c.vencimiento

    # crear dos indices, el que corresponde y el de la fecha de
    # vencimiento de la cuota
    indice_posta = @cv.indice_para(Date.today)
    indice_mal = create(:indice_cuota, valor: 1300, periodo: c.vencimiento)

    c.generar_factura
    f = Factura.last

    # la factura que se creó es la de la cuota...
    assert_equal c.factura, f
    # pero su fecha es la del periodo
    assert_not_equal c.vencimiento, f.fecha

    # y su valor es del monto_actualizado a ese periodo, no al del
    # vencimiento
    assert_equal c.monto_original * ( indice_posta.valor / @indice.valor ),
      f.importe_neto, [f, c.indice_actual(Date.today), @indice, indice_posta]
  end

  test 'a veces queremos especificar el indice de la factura' do
    c = @cv.cuotas.vencidas.sample
    # si la cuota no está vencida, Cuota.generar_factura siempre le va a
    # enchufar el mejor indice y no el que queremos
    assert c.vencida?, c.vencimiento

    # creamos un indice cualquiera en cualquier fecha
    p = (Date.today + 5.months).beginning_of_month
    indice_cualquiera = create(:indice_cuota, valor: 1300, periodo: p)
    # le decimos a la cuota que genere una factura en base a ese indice
    assert c.generar_factura(p), c.errors.messages.inspect
    # Cuota.indice_actual(p) debería devolver el indice que creamos a
    # propósito
    assert_equal indice_cualquiera, c.indice
    assert f = c.factura, c.inspect
    assert_equal c.monto_original * ( indice_cualquiera.valor / @indice.valor), f.importe_neto, [f.inspect, c.inspect]
  end

  test 'si el indice no existe se crea uno temporal' do
    c = @cv.cuotas.vencidas.pendientes.last

    assert c.generar_factura(c.vencimiento), c.errors.messages.inspect
    assert c.indice.temporal?, [c.inspect, c.indice.inspect]
    # como no se creó ningún índice más el utilizado es el indice
    # original
    assert_equal @indice.valor, c.indice.valor

    factura_importe_original = c.factura.importe_neto

    # al cambiar el valor del indice, se dispara la actualizacion de
    # montos de facturas por Indice.after_update
    c.indice.valor = c.indice.valor * 2
    assert c.indice.save
    refute c.indice.temporal?
    assert c.factura.reload

    assert_not_equal factura_importe_original, c.factura.importe_neto
    assert_not_equal factura_importe_original, c.factura.importe_total
  end

  test 'hay cuotas pendientes' do
    # se crearon las cuotas pero no se generaron facturas para ninguna
    # por lo que todas están pendientes
    assert_equal @cv.cuotas.count, @cv.cuotas.pendientes.count
  end

  test 'hay cuotas que ya estan emitidas' do
    assert_difference('@cv.cuotas.pendientes.count', -1) do
      @cv.cuotas.first.generar_factura
    end

    assert_equal 1, @cv.cuotas.emitidas.count
  end
end
