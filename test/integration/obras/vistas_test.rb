# encoding: utf-8
require './test/test_helper'

feature 'Vistas mínimas' do
  background do
    @obra =  create :obra
  end

  scenario 'Se lista la obra' do
    visit obras_path

    page.must_have_content @obra.nombre
  end

  scenario 'Se puede acceder a vista detallada' do
    visit obra_path(@obra)

    find('input#obra_nombre').value.must_equal @obra.nombre
    find('input#obra_direccion').value.must_equal @obra.direccion
    page.must_have_link 'Listar Obras', obras_path
    page.must_have_link 'Editar Obra', edit_obra_path(@obra)
  end

  scenario 'Widgets en vista detallada' do
    visit obra_path(@obra)

    page.must_have_content 'Situación Económica'
    page.must_have_content 'Situación Financiera'
    page.must_have_content 'Unidades Funcionales'
    page.must_have_link 'Listar Unidades Funcionales', obra_unidades_funcionales_path(@obra)
  end

  scenario 'Se crean las cuentas, cajas y chequeras automáticamente' do
    visit obra_cajas_path(@obra)

    page.must_have_content 'Obra'
    page.must_have_content 'Administración'
    page.must_have_content 'Seguridad'
    page.must_have_content 'Administración B'
    page.must_have_content 'Cuenta Corriente'
    page.must_have_content 'Cheques en Cartera B'
    page.must_have_content 'Cheques en Cartera'
    page.must_have_content 'Cheques Propios'
    page.must_have_content 'Retenciones de Ganancias'
    page.must_have_content 'Retenciones de Cargas Sociales'
  end

  scenario 'Navega a editar obra' do
    visit obra_path(@obra)

    click_link 'Editar Obra'
    current_path.must_equal edit_obra_path(@obra)
  end

  scenario 'Navega a listado de obras' do
    visit obra_path(@obra)

    click_link 'Listar Obras'
    current_path.must_equal obras_path
  end
end
