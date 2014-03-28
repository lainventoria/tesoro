# encoding: utf-8
require 'test_helper'

class ReciboPagarConTest < ActiveSupport::TestCase
  setup do
    @factura = create :factura, situacion: 'pago'
  end

  test "se puede pagar con efectivo" do
    recibo = @factura.pagar Money.new(100)
    medio_de_pago = Efectivo.new monto: Money.new(100),
      caja: create(:caja, :con_fondos, monto: Money.new(100))

    assert recibo.pagar_con(medio_de_pago)
  end
end
