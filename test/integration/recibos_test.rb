# encoding: utf-8
require './test/test_helper'

feature 'Recibos' do
  feature 'Borrar' do
    background do
      @recibo = create :recibo
    end

    scenario 'Esta el boton' do
      visit edit_factura_recibo_path(@recibo.factura, @recibo)
      page.must_have_content 'Editar Recibo'
      page.must_have_link 'Borrar Recibo'
    end

    scenario 'Un pago efectivo' do
      @recibo.pagar_con efectivo_por(Money.new(100))
      @recibo.save

      visit edit_factura_recibo_path(@recibo.factura, @recibo)
      page.must_have_link 'Efectivo',
        href: obra_caja_path(@recibo.movimientos.last.caja.obra, @recibo.movimientos.last.caja)

      find('a.btn.btn-danger[data-method=delete]').click

      page.must_have_content 'Factura por Pagar'
    end

    scenario 'Un pago cheque' do
      cheque = create :cheque, monto: Money.new(100)
      @recibo.pagar_con cheque
      @recibo.save

      visit edit_factura_recibo_path(@recibo.factura, @recibo)

      page.must_have_link 'Cheque',
        href: obra_caja_cheque_path(@recibo.movimientos.last.caja.obra, @recibo.movimientos.last.caja, @recibo.movimientos.last.causa)

      find('a.btn.btn-danger[data-method=delete]').click

      page.must_have_content 'No se puede borrar'
    end

    scenario 'Un pago retencion' do
      retencion = create :retencion, monto: Money.new(100)
      @recibo.pagar_con retencion
      @recibo.save

      visit edit_factura_recibo_path(@recibo.factura, @recibo)

      page.must_have_content 'Retencion'
      page.must_have_content 100

      find('a.btn.btn-danger[data-method=delete]').click

      page.must_have_content 'No se puede borrar'
    end
  end
end
