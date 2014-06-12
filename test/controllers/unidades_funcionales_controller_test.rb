# encoding: utf-8
require 'test_helper'

class UnidadesFuncionalesControllerTest < ActionController::TestCase
  setup do
    @unidad = create :unidad_funcional
  end

  test "accede a la lista de unidades" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cajas)
  end

  test "accede a crear" do
    get :new
    assert_response :success
  end

  test "crea" do
    obra = create :obra
    assert_difference('UnidadFuncional.count') do
      post :create, unidad_funcional: attributes_for(:unidad_funcional, obra_id: obra)
    end

    assert_redirected_to obra_unidad_funcional_path(assigns(:unidad_funcional))
  end

  test "muestra" do
    get :show, id: @unidad
    assert_response :success
  end

  test "muestra a través de su obra" do
    get :show, obra_id: @unidad.obra, id: @unidad
    assert_response :success
  end

  test "accede a editar" do
    get :edit, id: @unidad
    assert_response :success
  end

  test "actualiza" do
    patch :update, id: @unidad, unidad_funcional: { tipo: 'Departamento' }
    assert_redirected_to obra_unidad_funcional_path(unidad = assigns(:unidad_funcional))

    assert_equal 'Departamento', unidad.tipo
  end

  test "destruye" do
    assert_difference('UnidadFuncional.count', -1) do
      delete :destroy, id: @unidad
    end

    assert_redirected_to obra_unidades_funcionales_path(@unidad.obra)
  end
end
