require 'test_helper'

class WorksControllerTest < ActionController::TestCase
  setup do
    @work = works(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:works)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work" do
    assert_difference('Work.count') do
      post :create, work: { desciption: @work.desciption, favorites_count: @work.favorites_count, image: @work.image, likes_count: @work.likes_count, shares_count: @work.shares_count, title: @work.title, user_id: @work.user_id, views_count: @work.views_count }
    end

    assert_redirected_to work_path(assigns(:work))
  end

  test "should show work" do
    get :show, id: @work
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work
    assert_response :success
  end

  test "should update work" do
    patch :update, id: @work, work: { desciption: @work.desciption, favorites_count: @work.favorites_count, image: @work.image, likes_count: @work.likes_count, shares_count: @work.shares_count, title: @work.title, user_id: @work.user_id, views_count: @work.views_count }
    assert_redirected_to work_path(assigns(:work))
  end

  test "should destroy work" do
    assert_difference('Work.count', -1) do
      delete :destroy, id: @work
    end

    assert_redirected_to works_path
  end
end
