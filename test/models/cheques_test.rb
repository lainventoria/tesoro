require 'test_helper'

class ChequeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "es valido" do
    assert (c = create(:cheque)).valid?, c.errors.messages
  end

  test "el cheque está vencido" do
    cheque = create :cheque, fecha_vencimiento: Time.now - 360000

    assert cheque.vencido?, "#{Time.now} > #{cheque.fecha_vencimiento}"
  end

  test "el cheque no está vencido" do
    cheque = create :cheque

    assert_not cheque.vencido?, "#{Time.now} > #{cheque.fecha_vencimiento}"
  end
end
