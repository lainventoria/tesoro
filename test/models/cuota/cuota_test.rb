# encoding: utf-8
require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
  test 'necesita monto_original' do
    m = build(:cuota, monto_original_centavos: nil)
    refute m.save
  end

  test 'necesita vencimiento' do
    m = build(:cuota, vencimiento: nil)
    refute m.save
  end

  test 'necesita descripcion' do
    m = build(:cuota, descripcion: nil)
    refute m.save
  end
end
