# encoding: utf-8
require 'test_helper'

class RecibosControllerTest < ActionController::TestCase
  setup do
    @factura = create :factura, importe_neto: Money.new(3000),
      iva: Money.new(3000 * 0.21)
  end

  test 'accede a la lista global de recibos de pago' do
    create :recibo, situacion: 'cobro',
      factura: create(:factura, situacion: 'cobro')
    create :recibo, situacion: 'pago',
      factura: create(:factura, situacion: 'pago')
    create :recibo, situacion: 'interno'

    assert Recibo.count == 3
    assert Recibo.where(situacion: 'pago').count == 1

    get :pagos
    assert_response :success
    assert_not_nil assigns(:recibos)
    assert assigns(:recibos).count == 1
  end

  test 'accede a la lista global de recibos de cobro' do
    create :recibo, situacion: 'cobro',
      factura: create(:factura, situacion: 'cobro')
    create :recibo, situacion: 'pago',
      factura: create(:factura, situacion: 'pago')
    create :recibo, situacion: 'interno'

    assert Recibo.count == 3
    assert Recibo.where(situacion: 'cobro').count == 1

    get :cobros
    assert_response :success
    assert_not_nil assigns(:recibos)
    assert assigns(:recibos).count == 1
  end

  test 'accede a la lista de recibos de pago' do
    get :pagos, factura_id: @factura
    assert_response :success
    assert_not_nil assigns(:recibos)
  end

  test 'accede a la lista de recibos de cobro' do
    get :cobros, factura_id: @factura
    assert_response :success
    assert_not_nil assigns(:recibos)
  end

  test 'accede a la lista de la obra de recibos de pago' do
    recibo = create :recibo, situacion: 'pago'

    get :pagos, obra_id: recibo.obra
    assert_response :success
    assert_not_nil assigns(:recibos)
  end

  test 'accede a la lista de la obra de recibos de cobro' do
    recibo = create :recibo, situacion: 'cobro'

    get :cobros, obra_id: recibo.obra
    assert_response :success
    assert_not_nil assigns(:recibos)
  end

  test 'accede a crear' do
    get :new, factura_id: @factura
    assert_response :success
  end

  test 'accede a crear con recibo retencioso' do
    retencion = create :retencion, factura: @factura
    @factura.reload

    get :new, factura_id: @factura

    assert_redirected_to edit_factura_recibo_path(@factura,@factura.recibo_de_retenciones)
  end

  test 'crea' do
    importe_permitido = @factura.saldo

    assert_difference('Recibo.count') do
      post :create,
        factura_id: @factura,
        recibo: attributes_for( :recibo, importe: importe_permitido, factura_id: @factura),
        causa_tipo: 'cheque-de-terceros',
        causa: { cheque_id: create(:cheque) }
    end

    assert_redirected_to factura_recibo_path(@factura, assigns(:recibo))
  end

  test 'muestra' do
    get :show, id: create(:recibo, factura: @factura), factura_id: @factura
    assert_response :success
  end

  test 'muestra a través de su obra' do
    recibo_interno = @factura.obra.cajas.first.depositar!(Money.new(1000))

    get :show, obra_id: @factura.obra, id: recibo_interno
    assert_response :success
  end

  test 'no muestra a través de otra obra' do
    # Rails devuelve un 404 por default con estos errores en producción
    assert_raise ActiveRecord::RecordNotFound do
      get :show, obra_id: create(:obra), id: create(:recibo, factura: @factura)
    end
  end

  test 'accede a editar' do
    get :edit, id: create(:recibo, factura: @factura), factura_id: @factura
    assert_response :success
  end

  test 'actualiza' do
    recibo = create :recibo, factura: @factura

    importe_permitido = @factura.saldo
    assert patch :update, id: recibo, factura_id: @factura, recibo: attributes_for(
      :recibo, importe: importe_permitido, factura_id: @factura)
    assert_response :success
  end

  test 'destruye' do
    recibo = create :recibo, factura: @factura

    assert_difference('Recibo.count', -1) do
      delete :destroy, id: recibo, factura_id: @factura
    end

    assert_redirected_to factura_path(@factura)
  end
end
