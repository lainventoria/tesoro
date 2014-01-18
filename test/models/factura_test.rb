require 'test_helper'

class FacturaTest < ActiveSupport::TestCase
  test 'es un pago?' do
    assert build(:factura).pago?
  end
end
