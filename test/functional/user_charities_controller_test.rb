require 'test_helper'

class UserCharitiesControllerTest < ActionController::TestCase
  setup do
    @user_charity = user_charities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_charities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_charity" do
    assert_difference('UserCharity.count') do
      post :create, user_charity: @user_charity.attributes
    end

    assert_redirected_to user_charity_path(assigns(:user_charity))
  end

  test "should show user_charity" do
    get :show, id: @user_charity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_charity
    assert_response :success
  end

  test "should update user_charity" do
    put :update, id: @user_charity, user_charity: @user_charity.attributes
    assert_redirected_to user_charity_path(assigns(:user_charity))
  end

  test "should destroy user_charity" do
    assert_difference('UserCharity.count', -1) do
      delete :destroy, id: @user_charity
    end

    assert_redirected_to user_charities_path
  end
end
