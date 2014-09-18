# encoding: utf-8
require './test/test_helper'

feature 'Avisar que falta el índice de construcción de este mes' do
  scenario 'Todavía no se cargaron los índices del mes' do
    create :indice, :para_cuotas, periodo: Date.today.last_month.beginning_of_month
    visit root_path

    page.must_have_content I18n.t(:avisar_si_faltan_indices)
  end

  scenario 'Ya se cargó un índice este mes' do
    create :indice, :para_cuotas, periodo: Date.today.beginning_of_month
    visit root_path

    page.wont_have_content I18n.t(:avisar_si_faltan_indices)
  end
end
