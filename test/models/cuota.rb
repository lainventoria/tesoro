require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
  test "es válida" do
    [ :build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :cuota
    end
  end

  test "necesita monto_original" do
    assert m = build(:cuota, monto_original_centavos: nil)
    assert_not m.save
  end

  test "necesita vencimiento" do
    assert m = build(:cuota, vencimiento: nil)
    assert_not m.save
  end

  test "necesita descripcion" do
    assert m = build(:cuota, descripcion: nil)
    assert_not m.save
  end

end
