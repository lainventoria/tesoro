require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
  setup do
    @indice = create(:indice, valor: 1100, periodo: '2014-05-01')
    @cv = create(:contrato_de_venta, indice: @indice, fecha: '2014-05-01')

    @cv.valid?
    @cv.hacer_pago_inicial(@cv.monto_total * 0.1)
    @cv.crear_cuotas(12)
  end

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
    assert indice_siguiente = create(:indice, valor: 1200, periodo: '2014-06-01')

    assert cuota = @cv.cuotas.where(vencimiento: '2014-06-01').first

    assert_equal indice_siguiente, cuota.indice_actual
    assert_equal cuota.monto_original * (indice_siguiente.valor / @indice.valor), cuota.monto_actualizado
  end

  test "listar cuotas vencidas" do
    # todas las cuotas vencidas de acá a 5 meses
    assert_equal 5, Cuota.vencidas('2014-05-01'.to_time + 5.months).count
  end

  test "algunas cuotas están vencidas" do
    assert Cuota.vencidas.first.vencida?
  end

  test "las cuotas generan facturas de cobro" do
    c = @cv.cuotas.first
    assert c.generar_factura, c.errors.messages.inspect

    f = Factura.last

    assert_equal c.factura, f
    assert f.cobro?
    assert_equal c.monto_actualizado, f.importe_neto
    assert_equal c.tercero, f.tercero
    assert_equal c.obra, f.obra
  end

end
