# encoding: utf-8
require './test/test_helper'

feature 'Avisar que faltan indices' do
  background { create :indice, :para_cuotas }

  scenario 'todavía no se cargaron los indices del mes' do
    visit root_path

    page.must_have_content 'No hay indices cargados'
  end

  scenario 'ir y cargar el indice', js: true do
    indice = Indice.presente

    visit edit_indice_path(indice)

    find('#btnGuardar').click

    page.wont_have_content 'No hay indices cargados'

  end
end
