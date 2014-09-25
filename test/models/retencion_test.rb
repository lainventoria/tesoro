# encoding: utf-8
require 'test_helper'

class RetencionTest < ActiveSupport::TestCase
  test 'no se puede asociar a un cobro' do
    cobro = build :factura, situacion: 'cobro'

    refute build(:retencion, factura: cobro).valid?
  end

  test 'borrar retenciones borra sus movimientos' do
    retencion = create :retencion, monto: Money.new(1000)
    recibo = retencion.recibos.last

    assert recibo.movimientos.any?
    assert retencion.destroy
    assert recibo.reload.movimientos.count == 0
  end

  test 'crear la retención y que este todo piola' do
    retencion = create :retencion, monto: Money.new(1000)
    assert retencion.recibos.any?
    assert retencion.recibos.last.movimientos.any?
  end

  test 'crea dos retenciones y que no cree recibos redundantes' do
    factura = create :factura
    retencion1 = create :retencion, situacion: 'ganancias',
      monto: Money.new(100), factura: factura
    factura.reload
    retencion1.reload
    retencion2 = create :retencion, situacion: 'cargas_sociales',
      monto: Money.new(100), factura: factura
    retencion2.reload
    assert retencion1.recibos.last == retencion2.recibos.last
    assert retencion1.recibos.last.importe == Money.new(200)
  end

  test 'crea la retención y lo descuenta de la factura' do
    factura = create :factura, importe_neto: Money.new(100), iva: 0
    retencion = create :retencion, monto: Money.new(50), factura: factura
    assert factura.reload.saldo == Money.new(50)
  end
end
