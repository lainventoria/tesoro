require 'test_helper'

class ThirdPartiesControllerTest < ActionController::TestCase
  setup do
    @third_party = third_parties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:third_parties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create third_party" do
    assert_difference('ThirdParty.count') do
      post :create, third_party: { address: @third_party.address, cellphone: @third_party.cellphone, email: @third_party.email, name: @third_party.name, phone: @third_party.phone, tax: @third_party.tax }
    end

    assert_redirected_to third_party_path(assigns(:third_party))
  end

  test "should show third_party" do
    get :show, id: @third_party
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @third_party
    assert_response :success
  end

  test "should update third_party" do
    patch :update, id: @third_party, third_party: { address: @third_party.address, cellphone: @third_party.cellphone, email: @third_party.email, name: @third_party.name, phone: @third_party.phone, tax: @third_party.tax }
    assert_redirected_to third_party_path(assigns(:third_party))
  end

  test "should destroy third_party" do
    assert_difference('ThirdParty.count', -1) do
      delete :destroy, id: @third_party
    end

    assert_redirected_to third_parties_path
  end
end
