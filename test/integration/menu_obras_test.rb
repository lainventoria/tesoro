# encoding: utf-8
require './test/test_helper'

feature 'Menu de obras' do
  background do
    @obra = create :obra
  end

  # Cobros y Pagos
  scenario 'Las facturas de pago se filtran por obra' do
    visit pagos_facturas_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: pagos_facturas_path
      page.click_link @obra.nombre
    end

    current_path.must_equal pagos_obra_facturas_path(@obra)
  end

  scenario 'Los recibos de pago se filtran por obra' do
    visit pagos_recibos_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: pagos_recibos_path
      page.click_link @obra.nombre
    end

    current_path.must_equal pagos_obra_recibos_path(@obra)
  end

  scenario 'Las facturas de cobro se filtran por obra' do
    visit cobros_facturas_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: cobros_facturas_path
      page.click_link @obra.nombre
    end

    current_path.must_equal cobros_obra_facturas_path(@obra)
  end

  scenario 'Los recibos de cobro se filtran por obra' do
    visit cobros_recibos_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: cobros_recibos_path
      page.click_link @obra.nombre
    end

    current_path.must_equal cobros_obra_recibos_path(@obra)
  end

  # Configuración
  scenario 'Las obras se filtran por obra (?)' do
    visit obras_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: root_path
      page.click_link @obra.nombre
    end

    current_path.must_equal obra_path(@obra)
  end

  scenario 'Los índices no se filtran por obra' do
    visit indices_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: indices_path
      page.click_link @obra.nombre
    end

    current_path.must_equal indices_path
  end

  scenario 'Los terceros no se filtran por obra' do
    visit terceros_path

    within '#listado_de_obras' do
      page.must_have_link 'Todas las obras', href: terceros_path
      page.click_link @obra.nombre
    end

    current_path.must_equal terceros_path
  end
end
