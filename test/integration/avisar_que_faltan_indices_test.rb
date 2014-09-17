# encoding: utf-8
require './test/test_helper'

feature 'Avisar que falta el índice de construcción de este mes' do
  # que al menos haya un indice anterior
  background { create :indice, :para_cuotas }

  scenario 'Todavía no se cargaron los índices del mes' do
    visit root_path

    page.must_have_content I18n.t(:avisar_si_faltan_indices)
  end

  scenario 'Ir y cargar el índice', js: true do
    indice = create :indice, :para_cuotas, temporal: true,
      periodo: Date.today.beginning_of_month

    visit edit_indice_path(indice)

    find('#btnGuardar').click

    page.wont_have_content I18n.t(:avisar_si_faltan_indices)
  end
end
