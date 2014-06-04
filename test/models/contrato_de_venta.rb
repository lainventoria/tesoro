# encoding: utf-8
require 'test_helper'

class ContratoDeVentaTest < ActiveSupport::TestCase
  test "es válido" do
    [ :build, :build_stubbed, :create ].each do |metodo|
      assert_valid_factory metodo, :contrato_de_venta
    end
  end

  test "el contrato tiene un pago inicial" do
    cv = create(:contrato_de_venta, monto_total: Money.new(100000 * 100))

    assert cv.hacer_pago_inicial(Money.new(1000 * 100))
    assert_equal 'Pago inicial', cv.cuotas.first.descripcion
    assert_equal Money.new(1000 * 100), cv.cuotas.first.monto_original
  end
end
