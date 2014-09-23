# encoding: utf-8
require 'test_helper'

class RetencionTest < ActiveSupport::TestCase
  test 'no se puede asociar a un cobro' do
    cobro = build :factura, situacion: 'cobro'

    refute build(:retencion, factura: cobro).valid?
  end

  test 'borrar retenciones borra sus movimientos' do
    recibo = create :recibo
    retencion = create :retencion, monto: Money.new(1000)
    recibo.pagar_con retencion

    assert recibo.movimientos.any?
    assert retencion.destroy
    assert recibo.reload.movimientos.count == 0
  end


  test 'borrar el recibo temporal y que este todo piola' do
    retencion = create :retencion, monto: Money.new(1000)
    recibo = create :recibo, situacion: 'pago'
    retencion.usar_para_pagar recibo
    assert Movimiento.any?
  end

end
