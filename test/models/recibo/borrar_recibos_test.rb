# encoding: utf-8
require 'test_helper'

class BorrarRecibosTest < ActiveSupport::TestCase
  setup do
    # FIXME por qué hay que recargar para que tome los movimientos?
    @recibo = create(:recibo, :con_movimientos).reload
  end

  test 'borra sus movimientos' do
    assert_difference -> { Movimiento.count }, -1 do
      assert @recibo.destroy
    end
  end

  test 'borra sus movimientos a menos que alguno tenga causa trackeable' do
    retencion = create :retencion, monto: Money.new(1000)
    @recibo.pagar_con retencion

    assert_no_difference -> { Movimiento.count } do
      refute @recibo.destroy
    end
  end

  test 'borra sus comprobantes y sus movimientos' do
    # Recibir $100 USD como pago por $1000 ARS
    @recibo.pagar_con build(:efectivo,
      monto: Money.new(100, 'USD'), monto_aceptado: Money.new(1000),
      caja: create(:caja, :con_fondos, monto: Money.new(100, 'USD')))
    comprobante = @recibo.comprobantes.first

    # Espero que esto cambie pronto
    assert_instance_of Recibo, comprobante
    assert comprobante.interno?
    assert comprobante.movimientos.count == 2

    assert_difference -> { Movimiento.count }, -4 do
      assert_difference -> { Recibo.count }, -2 do
        assert @recibo.destroy
      end
    end
  end
end
