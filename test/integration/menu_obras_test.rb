# encoding: utf-8
require './test/test_helper'

# testea app/helpers/application_helper.rb con_esta_obra()

feature 'Menu de obras' do
  background do
    @obra1 = create :obra
  end

  # Cobros y Pagos
  scenario 'Las facturas de pago se filtran por obra' do
    visit pagos_facturas_path

    page.must_have_link 'Todas las obras', href: pagos_facturas_path
    page.must_have_link @obra1.nombre, href: pagos_obra_facturas_path(@obra1)
  end

  scenario 'Los recibos de pago se filtran por obra' do
    visit pagos_recibos_path

    page.must_have_link 'Todas las obras', href: pagos_recibos_path
    page.must_have_link @obra1.nombre, href: pagos_obra_recibos_path(@obra1)
  end

  scenario 'Las facturas de cobro se filtran por obra' do
    visit cobros_facturas_path

    page.must_have_link 'Todas las obras', href: cobros_facturas_path
    page.must_have_link @obra1.nombre, href: cobros_obra_facturas_path(@obra1)
  end

  scenario 'Los recibos de cobro se filtran por obra' do
    visit cobros_recibos_path

    page.must_have_link 'Todas las obras', href: cobros_recibos_path
    page.must_have_link @obra1.nombre, href: cobros_obra_recibos_path(@obra1)
  end

  # Configuración
  scenario 'Las obras se filtran por obra (?)' do
    visit obras_path
    page.must_have_link 'Todas las obras', href: root_path
    page.must_have_link @obra1.nombre, href: obra_path(@obra1)
  end

  scenario 'Los índices no se filtran por obra' do
    visit indices_path

    page.must_have_link 'Todas las obras', href: indices_path
    page.must_have_link @obra1.nombre, href: indices_path
  end

  scenario 'Los terceros no se filtran por obra' do
    visit terceros_path

    page.must_have_link 'Todas las obras', href: terceros_path
    page.must_have_link @obra1.nombre, href: terceros_path
  end
end
