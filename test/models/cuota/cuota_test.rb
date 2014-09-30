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

  test 'obtiene las cuotas cobradas' do
    (create :cuota, vencimiento: Date.yesterday).generar_factura

    assert_difference 'Cuota.cobradas.count' do
      r = build :recibo, factura: Cuota.first.factura
      r.pagar_con efectivo_por(Cuota.first.factura.importe_total)
    end
  end
end
