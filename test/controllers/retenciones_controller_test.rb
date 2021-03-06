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
          situacion: :cargas_sociales,
          monto: @factura.importe_neto * 0.2,
          fecha_vencimiento:  Date.tomorrow,
          documento: fixture_file_upload('retencion.pdf', 'application/pdf')
        }
    end
  end

  test 'paga una retención' do
    cuenta = create :caja, :con_fondos,
      monto: @retencion.monto,
      obra: @retencion.obra,
      situacion: 'banco',
      banco: 'los odio a todos'

    put :pagar, obra_id: @retencion.obra,
      factura_id: @factura,
      retencion_id: @retencion,
      retencion: { cuenta_id: cuenta }
    assert_redirected_to retenciones_path

    @retencion.reload

    assert_equal 'cerrada', @retencion.estado
    assert_equal 0, cuenta.total
    assert_equal 0, @retencion.chequera.total
  end

  test 'no paga una retención si la cuenta no es banco' do
    cuenta = create :caja, :con_fondos,
      monto: @retencion.monto,
      situacion: 'efectivo'

    put :pagar, obra_id: @retencion.obra,
      factura_id: @factura,
      retencion_id: @retencion,
      retencion: { cuenta_id: cuenta }
    assert_redirected_to edit_obra_factura_retencion_path(@retencion.obra, @factura, @retencion)
    assert_equal I18n.t('retenciones.tiene_que_ser_un_banco'), request.flash[:notice]
  end
end
