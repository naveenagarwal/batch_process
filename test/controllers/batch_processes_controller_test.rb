require 'test_helper'

class BatchProcessesControllerTest < ActionController::TestCase
  setup do
    @batch_process = batch_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:batch_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create batch_process" do
    assert_difference('BatchProcess.count') do
      post :create, batch_process: { name: @batch_process.name }
    end

    assert_redirected_to batch_process_path(assigns(:batch_process))
  end

  test "should show batch_process" do
    get :show, id: @batch_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @batch_process
    assert_response :success
  end

  test "should update batch_process" do
    patch :update, id: @batch_process, batch_process: { name: @batch_process.name }
    assert_redirected_to batch_process_path(assigns(:batch_process))
  end

  test "should destroy batch_process" do
    assert_difference('BatchProcess.count', -1) do
      delete :destroy, id: @batch_process
    end

    assert_redirected_to batch_processes_path
  end
end
