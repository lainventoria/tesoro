# encoding: utf-8
require './test/test_helper'

feature 'Avisar que faltan indices' do
  background { create :indice, :para_cuotas }

  scenario 'todavía no se cargaron los índices del mes' do
    visit root_path

    page.must_have_content 'No hay índices cargados'
  end

  scenario 'ir y cargar el indice', js: true do
    visit edit_indice_path(Indice.presente)

    find('#btnGuardar').click

    page.wont_have_content 'No hay índices cargados'
  end
end
