# encoding: utf-8
require 'test_helper'

class ContratosDeVentaControllerTest < ActionController::TestCase
  setup do
    @contrato = create :contrato_de_venta
  end

  test "accede a la lista de contratos" do
    get :index, obra_id: @contrato.obra
    assert_response :success
    assert_not_nil assigns(:contratos)
  end

  test "accede a crear" do
    get :new, obra_id: @contrato.obra
    assert_response :success
  end

  test "crea" do
    obra = create :obra
    assert_difference('ContratoDeVenta.count') do
      post :create, obra_id: obra, contrato_de_venta: attributes_for(:contrato_de_venta, obra_id: obra)
    end
    contrato = assigns(:contrato)
    assert_redirected_to obra_contrato_de_venta_path(obra, contrato )
  end

  test "muestra a través de su obra" do
    get :show, obra_id: @contrato.obra, id: @contrato
    assert_response :success
  end

  test "accede a editar" do
    get :edit, id: @contrato, obra_id: @contrato.obra
    assert_response :success
  end

  test "actualiza" do
    monto_original = @contrato.monto_total
    unidad = create :unidad_funcional

    patch :update, id: @contrato, obra_id: @contrato.obra, contrato_de_venta: { unidad_id: [unidad] }

    contrato = assigns(:contrato)
    assert_redirected_to obra_contrato_de_venta_path(contrato.obra,contrato)
    assert  contrato.monto_total > monto_original
  end

  test "destruye" do
    assert_difference('ContratoDeVenta.count', -1) do
      delete :destroy, id: @contrato, obra_id: @contrato.obra
    end

    assert_redirected_to obra_contrato_de_venta_path(@contrato.obra)
  end
end

