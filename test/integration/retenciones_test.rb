# encoding: utf-8
require './test/test_helper'

feature 'Retenciones' do
  background do
    @factura = create :factura
  end

  scenario 'Esta el boton' do
    visit factura_path(@factura)
    page.must_have_link 'Retencion', new_obra_factura_retencion_path(
      @factura.obra, @factura)
  end

  scenario 'Se pueden crear' do
    visit new_obra_factura_retencion_path(@factura.obra, @factura)

    select 'Cargas Sociales', from: 'retencion_situacion'
    fill_in 'retencion_monto', with: '400'
    fill_in 'retencion_fecha_vencimiento', with: Date.tomorrow
    file = File.expand_path('../fixtures/retencion.pdf', File.dirname(__FILE__))
    attach_file 'retencion_documento', file

    find('#btnGuardar').click
  end

  scenario 'Aparecen en el recibo' do
    retencion = create :retencion, factura: @factura, monto: Money.new(100)
    @factura.reload
    recibo = @factura.recibos.last

    visit edit_factura_recibo_path(recibo.factura, recibo)

    page.must_have_link 'Retención',
      href: obra_caja_retencion_path(recibo.movimientos.last.caja.obra, recibo.movimientos.last.caja, recibo.movimientos.last.causa)

    find('a.btn.btn-danger[data-method=delete]').click

    page.must_have_content 'No se puede borrar'
  end
end
