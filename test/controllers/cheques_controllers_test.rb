require 'test_helper'

class ChequesControllerTest < ActionController::TestCase
  setup do
    @cuenta = create :cuenta
    @cheque = create :cheque
  end

  test "lista de cheques" do
    get :index
    assert_response :success
  end

  test "lista de cheques vencidos" do
    get :vencidos

    assert_response :vencidos
  end

  test "accede a crear" do
    get :new, cuenta_id: @cuenta

    assert_response :success
  end

  test "crear cheque" do
    assert_difference('Cheque.count') do
      post :create, cuenta_id: @cuenta
    end
  end

  test "mostrar" do
    get :show, id: @cheque

    assert_response :success
  end

  test "actualizar" do
    patch :update, cuenta_id: @cuenta, id: @cheque
  end
end
