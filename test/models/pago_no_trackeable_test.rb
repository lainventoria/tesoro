# encoding: utf-8
require 'test_helper'

# Testear sarasa!
class Sarasa < PagoNoTrackeable
end

class PagoNoTrackeableTest < ActiveSupport::TestCase
  test 'registra el monto en pesos por default' do
    assert_equal Money.new(100), Sarasa.new(monto: Money.new(100)).monto
  end

  test 'registra el monto' do
    assert_equal Money.new(100, 'USD'),
      Sarasa.new(monto: Money.new(100, 'USD')).monto
  end

  test 'el id es siempre el mismo' do
    assert_equal 1, Sarasa.new.id
  end

  test 'registra la caja a la que pertenece el movimiento de pago' do
    caja = create(:caja)
    assert_equal caja, Sarasa.new(caja: caja).caja
  end
end
