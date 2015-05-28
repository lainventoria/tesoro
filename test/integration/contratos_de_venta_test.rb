# encoding: utf-8
require './test/test_helper'

feature 'Contratos de Venta' do
  background do
    @obra = create :obra
    @uf = create :unidad_funcional, obra: @obra, precio_venta_centavos: 1000000
    @uf2 = create :unidad_funcional, obra: @obra, precio_venta_centavos: 1000000, descripcion: '2B'
  end

  scenario 'Cargar un nuevo contrato' do
    visit new_obra_contrato_de_venta_path(@obra)

    page.must_have_content 'Nuevo Contrato de Venta'
    page.must_have_content 'Agregar'
    page.must_have_content 'Generar Cuotas'
  end

  scenario 'Agregar una unidad funcional' do
    skip
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

  scenario 'Agregar varias unidades funcionales y cambiarles el precio' do
    skip
    visit new_obra_contrato_de_venta_path(@obra)

    within 'form' do
      @obra.unidades_funcionales.each do |uf|
        select(uf.para_mostrar, from: 'contrato_de_venta_unidades_funcionales')
        click_link('contrato_de_venta_unidad_funcional_agregar')
      end

      first('#contrato_de_venta_total').value.must_equal '20,000.00'

      within_table 'lista_unidades_funcionales' do
        fill_in("unidad_funcional_#{@uf.id}", with: '20,000.00')
      end

      first('#contrato_de_venta_total').value.must_equal '30,000.00'
    end
  end

  scenario 'Generar cuotas' do
    skip
    visit new_obra_contrato_de_venta_path(@obra)

    within 'form' do
      select(@obra.unidades_funcionales.first.para_mostrar, from: 'contrato_de_venta_unidades_funcionales')
      click_link('contrato_de_venta_unidad_funcional_agregar')

      fill_in 'contrato_de_venta_cantidad_cuotas', with: '10'
      fill_in 'contrato_de_venta_monto_cuotas', with: '2000'
      fill_in 'contrato_de_venta_fecha_primera_cuota', with: '25/08/2014'

      click_link('contrato_de_venta_generar_cuotas')

      within '#contrato_de_venta_cuotas_table' do
        page.must_have_content '25 Aug 2014'

        all('.monto').count.must_equal 10
        all('.monto').each do |m|
          m.value.must_equal '2,000.00'
        end

      end

      find_by_id('cuotas_total').value.must_equal '20,000.00'
    end
  end
end
