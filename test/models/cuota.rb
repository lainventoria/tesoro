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

  test "el monto se actualiza en base al indice actual" do
    assert indice = create(:indice, valor: 1100, periodo: '2014-05-01')
    assert indice_siguiente = create(:indice, valor: 1200, periodo: '2014-06-01')

    assert cv = create(:contrato_de_venta, indice: indice, fecha: '2014-05-01')
    assert cv.valid?
    assert cv.hacer_pago_inicial(cv.monto_total * 0.1)
    assert cv.crear_cuotas(2)

    assert cuota = cv.cuotas.where(vencimiento: '2014-06-01').first

    assert_equal indice_siguiente, cuota.indice_actual
    assert_equal cuota.monto_original * (indice_siguiente.valor / indice.valor), cuota.monto_actualizado
  end

  test "listar cuotas vencidas" do
    assert cv = create(:contrato_de_venta)
    assert cv.valid?
    assert cv.hacer_pago_inicial(cv.monto_total * 0.1)
    assert cv.crear_cuotas(12)

    # todas las cuotas vencidas de acá a 5 meses
    assert_equal 5, Cuota.vencidas(Time.now + 5.months).count
  end

end
