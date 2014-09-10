# encoding: utf-8
require './test/test_helper'

feature 'Editar Obra' do
  background do
    @obra =  create :obra
    visit edit_obra_path(@obra)

    fill_in 'obra_nombre', with: 'nuevo nombre'
    fill_in 'obra_direccion', with: 'nueva direccion'
  end

  scenario 'Guardar cambios', js: true do
    find('#btnGuardar').click

    page.must_have_content 'Obra actualizada con éxito'
    find('input#obra_nombre').value.must_equal 'nuevo nombre'
    find('input#obra_direccion').value.must_equal 'nueva direccion'
  end

  scenario 'Cancelar cambios' do
    click_link 'Volver a Obra'

    find('input#obra_nombre').value.must_equal @obra.nombre
    find('input#obra_direccion').value.must_equal @obra.direccion
  end
end
