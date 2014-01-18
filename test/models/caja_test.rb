require 'test_helper'

class CajaTest < ActiveSupport::TestCase
  test 'es válida' do
    assert (c = build(:caja)).valid?, c.errors.messages
  end

  test 'totaliza en pesos por default' do
    caja = create(:caja)
    2.times { create :movimiento, caja: caja, monto: Money.new(1000) }

    assert_equal Money.new(2000), caja.total
  end

  test 'totaliza por moneda' do
    caja = create(:caja)
    2.times { create :movimiento, caja: caja, monto: Money.new(1000) }
    2.times { create :movimiento, caja: caja, monto: Money.new(500, 'USD') }

    assert_equal Money.new(2000), caja.total
    assert_equal Money.new(1000, 'USD'), caja.total('USD')
  end
end
