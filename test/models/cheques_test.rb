require 'test_helper'

class ChequeTest < ActiveSupport::TestCase

  test "es valido" do
    assert (c = create(:cheque)).valid?, c.errors.messages
  end

  test "el cheque está vencido" do
    cheque = create :cheque, fecha_vencimiento: Time.now - rand(360000)

    assert cheque.vencido?, "#{Time.now} > #{cheque.fecha_vencimiento}"
  end

  test "el cheque no está vencido" do
    cheque = create :cheque

    assert_not cheque.vencido?, "#{Time.now} > #{cheque.fecha_vencimiento}"
  end

  test "algunos cheques se vencen" do
    cheque = create :cheque
    cheque2 = create :cheque, fecha_vencimiento: Time.now - rand(36000)

    assert cheque2.vencido?, cheque2.errors.messages

    assert_equal Cheque.count, 2
    assert_equal Cheque.vencidos.count, 1

  end

  test "los cheques propios no se depositan" do
    cheque = create :cheque, situacion: 'propio', estado: 'chequera'

    assert_not cheque.depositar
  end

  test "los cheques de terceros no se pagan" do
    cheque = create :cheque, situacion: 'terceros'

    assert_not cheque.pagar, cheque.errors.messages
  end

  test 'pagar un cheque genera movimientos en negativo' do
    cheque = create :cheque, situacion: 'propio'
    monto = cheque.monto

    assert cheque.pagar, cheque.errors.messages
    assert_equal monto * -1, cheque.recibo.movimientos.last.monto

  end
end
