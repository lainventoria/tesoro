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

  test "mostrar" do
    get :show, id: @cheque

    assert_response :success
  end
end
