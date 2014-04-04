require 'test_helper'

class CsvsControllerTest < ActionController::TestCase
  setup do
    @csv = csvs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:csvs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create csv" do
    assert_difference('Csv.count') do
      post :create, csv: {  }
    end

    assert_redirected_to csv_path(assigns(:csv))
  end

  test "should show csv" do
    get :show, id: @csv
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @csv
    assert_response :success
  end

  test "should update csv" do
    put :update, id: @csv, csv: {  }
    assert_redirected_to csv_path(assigns(:csv))
  end

  test "should destroy csv" do
    assert_difference('Csv.count', -1) do
      delete :destroy, id: @csv
    end

    assert_redirected_to csvs_path
  end
end
