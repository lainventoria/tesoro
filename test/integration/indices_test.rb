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
  end
end
