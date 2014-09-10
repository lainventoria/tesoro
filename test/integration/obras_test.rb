# encoding: utf-8
require './test/test_helper'

feature 'Obras' do
  background do
    @obra =  create :obra
  end

  feature 'Vistas minimas' do
    scenario 'Se lista la obra' do
      visit obras_path

      page.must_have_content @obra.nombre
    end

    scenario 'Se puede acceder a vista detallada' do
      visit obra_path(@obra)

      find(:css, 'input#obra_nombre').value == @obra.nombre
      find(:css, 'input#obra_direccion').value == @obra.direccion
      page.must_have_link 'Listar Obras', obras_path
      page.must_have_link 'Editar Obra', edit_obra_path(@obra)
    end

    scenario 'Widgets en vista detallada' do
      visit obra_path(@obra)

      page.must_have_content 'Situacion Economica'
      page.must_have_content 'Situacion Financiera'
      page.must_have_content 'Unidades Funcionales'
      page.must_have_link 'Listar Unidades Funcionales', obra_unidades_funcionales_path(@obra)
    end

    scenario 'Se crean las cuentas, cajas y chequeras automaticamente' do
      visit obra_cajas_path(@obra)

      page.must_have_content 'Obra'
      page.must_have_content 'Administración'
      page.must_have_content 'Seguridad'
      page.must_have_content 'Administración X'
      # TODO cambiar 'Caja de Ahorro' a 'Cta. Corriente' cuando se ajusten los
      # modelos para que se cree con ese nombre
      page.must_have_content 'Caja de Ahorro'
      page.must_have_content 'Chequera X'
      page.must_have_content 'Chequera'
      page.must_have_content 'Chequera propia'
      page.must_have_content 'Retenciones de Ganancias'
      page.must_have_content 'Retenciones de Cargas Sociales'
    end

    scenario 'Navega a editar obra' do
      visit obra_path(@obra)

      click_link 'Editar Obra'
      assert current_path == edit_obra_path(@obra)
    end

    scenario 'Navega a listado de obras' do
      visit obra_path(@obra)

      click_link 'Listar Obras'
      assert current_path == obras_path
    end
  end

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

      fill_in 'obra_nombre', :with => 'Obra Test'
      fill_in 'obra_direccion', :with => 'Obra Direccion'

      find('#btnGuardar').click
      page.must_have_content 'Obra creada con éxito'
    end
  end

  feature 'Editar Obra' do
    background do
      visit edit_obra_path(@obra)

      fill_in 'obra_nombre', :with => 'nuevo nombre'
      fill_in 'obra_direccion', :with => 'nueva direccion'
    end

    scenario 'Guardar cambios', js: true do
      find('#btnGuardar').click
      page.must_have_content 'Obra actualizada con éxito'
      find(:css, 'input#obra_nombre').value == 'nuevo nombre'
      find(:css, 'input#obra_direccion').value == 'nueva direccion'
    end

    scenario 'Cancelar cambios' do
      click_link 'Volver a Obra'
      find(:css, 'input#obra_nombre').value == @obra.nombre
      find(:css, 'input#obra_direccion').value == @obra.direccion
    end
  end
end
