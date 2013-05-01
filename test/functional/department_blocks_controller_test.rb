require 'test_helper'

class DepartmentBlocksControllerTest < ActionController::TestCase
  setup do
    @department_block = department_blocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:department_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create department_block" do
    assert_difference('DepartmentBlock.count') do
      post :create, department_block: @department_block.attributes
    end

    assert_redirected_to department_block_path(assigns(:department_block))
  end

  test "should show department_block" do
    get :show, id: @department_block
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @department_block
    assert_response :success
  end

  test "should update department_block" do
    put :update, id: @department_block, department_block: @department_block.attributes
    assert_redirected_to department_block_path(assigns(:department_block))
  end

  test "should destroy department_block" do
    assert_difference('DepartmentBlock.count', -1) do
      delete :destroy, id: @department_block
    end

    assert_redirected_to department_blocks_path
  end
end
