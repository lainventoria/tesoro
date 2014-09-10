# encoding: utf-8
require './test/test_helper'

feature 'Nueva Obra' do
  scenario 'Presenta formulario' do
    visit new_obra_path

    page.must_have_content 'Nueva Obra'
    page.must_have_content 'Nombre'
    page.must_have_content 'Direccion'

    page.must_have_content #obra_nombre
    page.must_have_content #obra_direccion

    page.must_have_link 'Volver al Listado'
    page.must_have_content 'Guardar Cambios'

  end

  scenario 'Llenar formulario', js: true do
    visit new_obra_path

    fill_in 'obra_nombre', with: 'Obra Test'
    fill_in 'obra_direccion', with: 'Obra Direccion'

    find('#btnGuardar').click
    page.must_have_content 'Obra creada con éxito'
  end
end
