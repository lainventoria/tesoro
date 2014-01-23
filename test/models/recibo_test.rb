require 'test_helper'

class ReciboTest < ActiveSupport::TestCase
  test "es válido" do
    # TODO arreglar las valicadiones en recibos y facturas
    assert (r = create(:recibo)).valid?, r.errors.messages
  end
end
