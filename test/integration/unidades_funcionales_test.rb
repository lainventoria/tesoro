# encoding: utf-8
require './test/test_helper'

feature 'Unidades Funcionales' do
  background do
    @obra = create :obra
    @uf = create :unidad_funcional, obra: @obra
    @cv = create :contrato_de_venta
    @cv.agregar_unidad_funcional @uf
    @uf.update_attribute(:precio_venta_final, Money.new(100000, 'ARS'))
  end

  scenario 'Listar unidades funcionales' do
    visit obra_unidades_funcionales_path(@obra)

    page.must_have_content @uf.tipo
    page.must_have_content @uf.descripcion
  end

  scenario 'Listar unidades funcionales vendidas' do
    visit obra_unidades_funcionales_path(@obra)

    within "tr[data-uri='#{obra_unidad_funcional_path(@obra, @uf)}']" do
      page.must_have_link 'vendida', obra_contrato_de_venta_path(@obra, @cv)
      page.must_have_content '1.000,00 ARS'
    end
  end

  scenario 'Mostrar el precio de venta final si la unidad está vendida' do
    visit obra_unidad_funcional_path(@obra, @uf)

    page.must_have_content '1.000,00 ARS'
  end
end
