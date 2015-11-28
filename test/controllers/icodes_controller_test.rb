require 'test_helper'

class IcodesControllerTest < ActionController::TestCase
  setup do
    @icode = icodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:icodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create icode" do
    assert_difference('Icode.count') do
      post :create, icode: { code: @icode.code, is_used: @icode.is_used, used_user_id: @icode.used_user_id, user_id: @icode.user_id }
    end

    assert_redirected_to icode_path(assigns(:icode))
  end

  test "should show icode" do
    get :show, id: @icode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @icode
    assert_response :success
  end

  test "should update icode" do
    patch :update, id: @icode, icode: { code: @icode.code, is_used: @icode.is_used, used_user_id: @icode.used_user_id, user_id: @icode.user_id }
    assert_redirected_to icode_path(assigns(:icode))
  end

  test "should destroy icode" do
    assert_difference('Icode.count', -1) do
      delete :destroy, id: @icode
    end

    assert_redirected_to icodes_path
  end
end
