# encoding: utf-8
require './test/test_helper'

feature 'Autocompletar terceros' do
  background do
    @tercero = create :tercero
  end

  scenario 'en los contratos', js: true do
    visit new_obra_contrato_de_venta_path(create(:obra))

    within 'form' do
      fill_in('contrato_de_venta_tercero_attributes_nombre', with: @tercero.nombre)
    end

    find('li.ui-menu-item').click

    within 'form' do
      page.must_have_content @tercero.cuit
    end
  end

  scenario 'en las facturas', js: true do
    visit new_obra_factura_path(create(:obra))

    within 'form' do
      fill_in('factura_tercero_attributes_nombre', with: @tercero.nombre)
    end

    find('li.ui-menu-item').click

    within 'form' do
      page.must_have_content @tercero.cuit
    end
  end
end
