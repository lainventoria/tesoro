# encoding: utf-8
require 'test_helper'

class RetencionesControllerTest < ActionController::TestCase
  setup do
    @factura = create :factura, importe_neto: Money.new(3000),
      iva: Money.new(3000 * 0.21)
    @retencion = create :retencion, factura: @factura
  end

  test 'accede a la lista de retenciones globales' do
    get :index
    assert_response :success
    assert_not_nil assigns(:retenciones)
  end

  test 'accede a la lista de retenciones de la factura' do
    get :index, factura_id: @factura
    assert_response :success
    assert_not_nil assigns(:retenciones)
  end

  test 'accede a la lista de retenciones de la obra' do
    get :index, obra_id: @factura.obra
    assert_response :success
    assert_not_nil assigns(:retenciones)
  end

  test 'muestra' do
    get :show, id: @retencion
    assert_response :success
  end

  test 'muestra a través de su factura' do
    get :show, id: @retencion, factura_id: @factura
    assert_response :success
  end

  test 'no muestra a través de otra factura' do
    assert_raise ActiveRecord::RecordNotFound do
      get :show, id: @retencion, factura_id: create(:factura)
    end
  end

  test 'muestra a través de su obra' do
    get :show, obra_id: @retencion.obra, id: @retencion
    assert_response :success
  end

  test 'no muestra a través de otra obra' do
    # Rails devuelve un 404 por default con estos errores en producción
    assert_raise ActiveRecord::RecordNotFound do
      get :show, obra_id: create(:obra), id: @retencion
    end
  end

  test 'crea retencion' do
    assert_difference('Retencion.count') do
      post :create, factura_id: @factura, retencion: {
          factura: @factura,
          situacion: :ganancias,
          monto: @factura.importe_neto * 0.2,
          fecha_vencimiento:  Date.tomorrow,

          # Un documento válido
          documento_file_name:     'fake.pdf',
          documento_content_type:  'application/pdf',
          documento_file_size:     1024,
          documento_updated_at:    '2014-04-06T04:24:29-03:00'
        }
    end

    # la retencion crea un recibo
    assert @factura.reload.recibos.last.movimientos.any?, 
      "tiene movimientos el recibo?"

  end
end
