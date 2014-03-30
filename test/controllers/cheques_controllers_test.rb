require 'test_helper'

class ChequesControllerTest < ActionController::TestCase
  setup do
    @caja = create :caja
    @cheque = create :cheque
  end

  test "lista de cheques" do
    get :index
    assert_response :success
  end

  test "mostrar" do
    get :show, id: @cheque

    assert_response :success
  end

  test "muestra a través de su obra" do
    get :show, obra_id: @cheque.obra, id: @cheque
    assert_response :success
  end

  test "no muestra a través de otra obra" do
    # Rails devuelve un 404 por default con estos errores en producción
    assert_raise ActiveRecord::RecordNotFound do
      get :show, obra_id: create(:obra), id: @cheque
    end
  end


end
