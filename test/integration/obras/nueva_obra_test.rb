# encoding: utf-8
require './test/test_helper'


feature 'Nueva Obra' do
  background do
    visit new_obra_path
  end

  scenario 'Presenta el formulario' do
    page.must_have_content 'Nueva Obra'
    page.must_have_content 'Nombre'
    page.must_have_content #obra_nombre
    page.must_have_content 'Direccion'
    page.must_have_content #obra_direccion
    page.must_have_link    'Volver al Listado'
    page.must_have_content 'Guardar Cambios'
  end

  scenario 'Crea una obra nueva', js: true do
    fill_in 'obra_nombre',    with: 'Obra Test'
    fill_in 'obra_direccion', with: 'Obra Direccion'
    find('#btnGuardar').click

    page.must_have_content 'Obra creada con éxito'
  end
end
