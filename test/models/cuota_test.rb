# encoding: utf-8
require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
  test 'es válida' do
    [:build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :cuota
    end
  end

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
