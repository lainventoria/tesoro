require 'test_helper'

class ChequeTest < ActiveSupport::TestCase
<<<<<<< HEAD
=======
  # test "the truth" do
  #   assert true
  # end
>>>>>>> 67ab0c05c4114a4cb90e1136b3f1ff91b5354426

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
end
