require 'test_helper'

class ChequesControllerTest < ActionController::TestCase
  setup do
    @cheque = create :cheque
  end

  test "lista de cheques" do
    get :index
    assert_response :success
  end

  test "mostrar" do
    get :show, obra_id: @cheque.chequera.obra, caja_id: @cheque.chequera, id: @cheque

    assert_response :success
  end

  test "muestra a través de su caja" do
    get :show, obra_id: @cheque.chequera.obra, caja_id: @cheque.chequera, id: @cheque
    assert_response :success
  end

  test "no muestra a través de otra obra" do
    # Rails devuelve un 404 por default con estos errores en producción
    assert_raise ActiveRecord::RecordNotFound do
      get :show, obra_id: create(:obra), caja_id: create(:caja), id: @cheque
    end
  end

  test "deposita" do
    patch :depositar, obra_id: @cheque.chequera.obra,
          caja_id: @cheque.chequera, id: @cheque,
          cheque: { cuenta_id: create(:caja) }

    assert_response :success
  end


end
