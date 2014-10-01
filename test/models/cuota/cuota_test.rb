# encoding: utf-8
require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
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

  test 'genera facturas sólo para las cuotas vencidas' do
    create(:cuota, vencimiento: Date.tomorrow)
    2.times { create(:cuota, vencimiento: Date.yesterday) }

    assert_difference 'Factura.count', 2 do
      assert_equal 2, Cuota.facturar_vencidas.size
    end
  end

  test 'una cuota vencida tiene estado correspondiente' do
    c = build(:cuota, vencimiento: Date.yesterday)

    assert_equal 'vencida', c.estado
  end

  test 'una cuota con factura tiene estado correspondiente' do
    c = build(:cuota, vencimiento: Date.yesterday)
    c.generar_factura

    assert_equal 'facturada', c.estado
  end

  test 'una cuota está cancelada cuando la factura se paga' do
    c = build(:cuota, vencimiento: Date.yesterday)
    c.generar_factura
    r = create(:recibo, factura: c.factura)
    r.pagar_con(Efectivo.new(monto: c.factura.importe_total,
      caja: create(:caja, :con_fondos, monto: c.factura.importe_total, tipo_factura: c.factura.tipo)))

    c.factura.reload

    assert_equal 'cobrada', c.estado
  end

  test 'obtiene las cuotas cobradas' do
    (create :cuota, vencimiento: Date.yesterday).generar_factura

    assert_difference 'Cuota.cobradas.count' do
      r = build :recibo, factura: Cuota.first.factura
      r.pagar_con efectivo_por(Cuota.first.factura.importe_total)
    end
  end
end
