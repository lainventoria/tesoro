require 'test_helper'

class ReciboTest < ActiveSupport::TestCase
  test "es válido" do
    # TODO arreglar las valicadiones en recibos y facturas
    assert (r = create(:recibo)).valid?, r.errors.messages
  end

  # Regresión para #6
  test "El recibo es válido si no completa la factura" do
    factura = create :factura, importe_total: Money.new(1000)
    recibo = factura.recibos.build importe: Money.new(800)

    assert recibo.valid?, recibo.errors.messages
    assert recibo.save
    assert recibo.reload.valid?, recibo.errors.messages
  end
end
