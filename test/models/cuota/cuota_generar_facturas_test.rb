# encoding: utf-8
require 'test_helper'

class CuotaGenerarFacturaTest < ActiveSupport::TestCase
  setup do
    @cuota = create(:cuota, vencimiento: Date.today)
    @factura = @cuota.generar_factura
  end

  test 'genera su propia factura' do
    assert_instance_of Factura, @factura
    assert_equal @cuota.factura, @factura
  end

  test 'las facturas son de cobro' do
    assert @factura.cobro?
  end

  test 'la factura cubre el monto de la cuota' do
    assert_equal @cuota.monto_actualizado, @factura.importe_neto
  end

  test 'la factura se le cobra al mismo cliente' do
    assert_equal @cuota.tercero, @factura.tercero
  end

  test 'la factura se relaciona con la obra de la cuota' do
    assert_equal @cuota.obra, @factura.obra
  end

  test 'se mantiene el tipo de transacción del contrato' do
    assert_equal @cuota.contrato_de_venta.tipo_factura, @factura.tipo
  end

  test 'hay un plazo de 10 días para pagar esa factura' do
    assert_equal @cuota.vencimiento + 10.days, @factura.fecha_pago.to_date
  end

  test 'si ya tiene factura no genera otra' do
    assert_equal @factura, @cuota.generar_factura
  end
end
