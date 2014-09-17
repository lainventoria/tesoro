# encoding: utf-8
require './test/test_helper'

feature 'Unidades Funcionales' do
  background do
    @obra = create :obra
    @uf = create :unidad_funcional, obra: @obra
  end

  scenario 'Listar unidades funcionales' do
    visit obra_unidades_funcionales_path(@obra)

    page.must_have_content @uf.tipo
    page.must_have_content @uf.descripcion
  end

  scenario 'Listar unidades funcionales vendidas' do
    cv = create :contrato_de_venta
    cv.agregar_unidad_funcional @uf

    visit obra_unidades_funcionales_path(@obra)

    within "tr[data-uri='#{obra_unidad_funcional_path(@obra, @uf)}']" do
      page.must_have_link 'vendida', obra_contrato_de_venta_path(@obra, cv)
    end
  end
end
