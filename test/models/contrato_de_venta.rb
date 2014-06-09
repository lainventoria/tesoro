# encoding: utf-8
require 'test_helper'

class ContratoDeVentaTest < ActiveSupport::TestCase
  test "es válido" do
    # FIXME build_stubbed falla con la creación de unidades_funcionales
    [ :build, :create ].each do |metodo|
      assert_valid_factory metodo, :contrato_de_venta
    end
  end

  test "el contrato tiene un pago inicial" do
    cv = create(:contrato_de_venta)

    assert cv.hacer_pago_inicial(Money.new(1000 * 100))
    assert_equal 'Pago inicial', cv.cuotas.first.descripcion
    assert_equal Money.new(1000 * 100), cv.cuotas.first.monto_original
  end

  test "el contrato tiene cuotas" do
    cv = create(:contrato_de_venta)
    # todo el after :build no calcula el monto_total
    cv.valid?

    # 10% del monto total
    pi = cv.monto_total * 0.1

    assert cv.hacer_pago_inicial(pi), cv.inspect
    assert cv.crear_cuotas(12), [ cv.monto_total, pi, cv.total_de_cuotas, cv.cuotas.count ]

    assert_equal 13, cv.cuotas.count

  end

  test "el monto original es la suma de las unidades funcionales" do
    cv = create(:contrato_de_venta)
    # el factory siempre agrega una
    total = cv.unidades_funcionales.first.precio_venta

    5.times {
      uf = create :unidad_funcional
      total += uf.precio_venta
      cv.agregar_unidad_funcional(uf)
    }

    assert_equal total, cv.monto_total
  end

  test "el tercero debe ser un cliente" do
    assert build(:contrato_de_venta, tercero: create(:proveedor)).invalid?
  end
end
