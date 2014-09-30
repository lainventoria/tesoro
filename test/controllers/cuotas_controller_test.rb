# encoding: utf-8
require 'test_helper'

class CuotasControllerTest < ActionController::TestCase
  setup do
    @cuota = create :cuota
  end

  test 'accede a la lista de cuotas' do
    get :index, obra_id: @cuota.contrato_de_venta.obra
    assert_response :success
    assert_not_nil assigns(:cuotas)
  end

  test 'muestra' do
    get :show, obra_id: @cuota.contrato_de_venta.obra, id: @cuota
    assert_response :success
  end

  test 'genera factura' do
    put :generar_factura, obra_id: @cuota.contrato_de_venta.obra, id: @cuota

    @cuota.reload

    assert_redirected_to obra_factura_path(@cuota.contrato_de_venta.obra, @cuota.factura)
    assert_instance_of Factura, @cuota.factura
  end
end
