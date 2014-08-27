# encoding: utf-8
require './test/test_helper'

feature "Contratos de Venta" do
  background do
    @obra = create :obra
    @tercero = create :tercero
  end

  scenario 'Cargar un nuevo contrato' do
    visit new_obra_contrato_de_venta_path(@obra)

    page.must_have_content "Nuevo Contrato de Venta"
    page.must_have_content "Agregar"
    page.must_have_content "Generar Cuotas"
  end

  scenario 'Buscar un tercero', js: true do
    visit new_obra_contrato_de_venta_path(@obra)

    within 'form' do
      fill_in('contrato_de_venta_tercero_attributes_nombre', with: @tercero.nombre)
    end

    page.must_have_selector('li.ui-menu-item')
    first('li.ui-menu-item').click

    within 'form' do
      page.must_have_content @tercero.cuit
    end

  end

  scenario 'Agregar una unidad funcional', js: true do
    @uf = create :unidad_funcional, obra: @obra, precio_venta_centavos: 1000000

    visit new_obra_contrato_de_venta_path(@obra)

    within 'form' do
      select(@uf.id, from: 'contrato_de_venta_unidades_funcionales')
      click_link('contrato_de_venta_unidad_funcional_agregar')

      within_table 'lista_unidades_funcionales' do
        page.must_have_content @uf.para_mostrar
        page.must_have_content @uf.precio_venta_moneda

        first('input.precio').value.must_equal '10,000.00'
      end
    end

  end

end
