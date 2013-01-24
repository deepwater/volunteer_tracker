require 'test_helper'

class UserAvailabilitiesControllerTest < ActionController::TestCase
  setup do
    @user_availability = user_availabilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_availabilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_availability" do
    assert_difference('UserAvailability.count') do
      post :create, user_availability: @user_availability.attributes
    end

    assert_redirected_to user_availability_path(assigns(:user_availability))
  end

  test "should show user_availability" do
    get :show, id: @user_availability
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_availability
    assert_response :success
  end

  test "should update user_availability" do
    put :update, id: @user_availability, user_availability: @user_availability.attributes
    assert_redirected_to user_availability_path(assigns(:user_availability))
  end

  test "should destroy user_availability" do
    assert_difference('UserAvailability.count', -1) do
      delete :destroy, id: @user_availability
    end

    assert_redirected_to user_availabilities_path
  end
end
