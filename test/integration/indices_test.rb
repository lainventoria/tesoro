# encoding: utf-8
require './test/test_helper'

feature 'Índices' do
  feature 'Precargados' do
    background { cargar_seeds }

    scenario 'Hay un índice precargado de cada tipo' do
      visit indices_path

      page.must_have_content 'Listado de Índices'
      page.must_have_link 'Nuevo Índice', href: new_indice_path

      within '#indices' do
        page.must_have_content 'Costo de construcción'
        page.must_have_content 'Materiales'
        page.must_have_content 'Mano de obra'
      end
    end

    scenario 'Los índices temporales muestran una etiqueta' do
      indice = create :indice, :para_cuotas, temporal: true

      visit indices_path

      within "tr[data-uri='#{indice_path(indice)}']" do
        page.must_have_link 'temporal', edit_indice_path(indice)
      end
    end

    scenario 'El índice tiene una lista de contratos asociados' do
      i = Indice.first
      cv = create :contrato_de_venta, indice: i, obra: (create :obra)

      visit indice_path(i)

      page.must_have_link nil, obra_contrato_de_venta_path(cv.obra, cv)
    end
  end
end
