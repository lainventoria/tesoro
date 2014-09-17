# encoding: utf-8
require './test/test_helper'

feature 'Unidades Funcionales' do
  background do
    cargar_seeds

    @obra = create :obra
    @uf = create :unidad_funcional, obra: @obra
  end

  scenario 'Listar unidades funcionales' do
    visit obra_unidades_funcionales_path(@obra)

    page.must_have_content @uf.tipo
    page.must_have_content @uf.descripcion
  end
end
