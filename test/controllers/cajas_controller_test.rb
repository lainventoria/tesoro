require 'test_helper'

class CajasControllerTest < ActionController::TestCase
  setup do
    @caja = create :caja
  end

  test "accede a la lista de cajas" do
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
    assert_difference('Caja.count') do
      post :create, caja: attributes_for(:caja, obra_id: obra)
    end

    assert_redirected_to caja_path(assigns(:caja))
  end

  test "muestra" do
    get :show, id: @caja
    assert_response :success
  end

  test "accede a editar" do
    get :edit, id: @caja
    assert_response :success
  end

  test "actualiza" do
    patch :update, id: @caja, caja: { tipo: 'Otro' }
    assert_redirected_to caja_path(caja = assigns(:caja))

    assert_equal 'Otro', caja.tipo
  end

  test "destruye" do
    assert_difference('Caja.count', -1) do
      delete :destroy, id: @caja
    end

    assert_redirected_to cajas_path
  end
end
