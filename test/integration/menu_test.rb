# encoding: utf-8
require './test/test_helper'

feature 'Menu' do
  background { visit root_path }

  scenario 'Al iniciar muestra la lista de obras' do
    page.must_have_content 'Listado de Obras'
    page.must_have_link 'Nueva Obra', href: new_obra_path
  end

  feature 'Sirve para navegar' do
    scenario 'Al inicio' do
      page.must_have_link nil, href: root_path
    end

    scenario 'A todas las obras' do
      page.must_have_button 'Todas las Obras'
      page.must_have_link 'Todas las obras', href: root_path
    end

    scenario 'A cobros y pagos' do
      page.must_have_link 'Cobros y Pagos', href: '#'

      page.must_have_link 'Facturas por Pagar', href: pagos_facturas_path
      page.must_have_link 'Recibos de Pagos', href: pagos_recibos_path

      page.must_have_link 'Facturas por Cobrar', href: cobros_facturas_path
      page.must_have_link 'Recibos de Cobros', href: cobros_recibos_path
    end

    scenario 'A cajas y bancos' do
      page.must_have_link 'Cajas y Bancos', href: '#'

      page.must_have_link 'Cajas y Cuentas', href: cajas_path

      page.must_have_link 'Cheques Propios', href: cheques_path(situacion: 'propio')
      page.must_have_link 'Cheques Terceros', href: cheques_path(situacion: 'terceros')
      page.must_have_link 'Cheques Vencidos', href: cheques_path(vencidos: true)
      page.must_have_link 'Cheques Depositados', href: cheques_path(depositados: true)

      page.must_have_link 'Retenciones', href: retenciones_path
    end

    scenario 'A la configuración' do
      page.must_have_link 'Configuración', href: '#'

      page.must_have_link 'Obras', href: obras_path
      page.must_have_link 'Terceros', href: terceros_path
      page.must_have_link 'Índices', href: indices_path
    end
  end
end
