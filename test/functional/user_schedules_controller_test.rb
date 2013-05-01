require 'test_helper'

class UserSchedulesControllerTest < ActionController::TestCase
  setup do
    @user_schedule = user_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_schedule" do
    assert_difference('UserSchedule.count') do
      post :create, user_schedule: @user_schedule.attributes
    end

    assert_redirected_to user_schedule_path(assigns(:user_schedule))
  end

  test "should show user_schedule" do
    get :show, id: @user_schedule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_schedule
    assert_response :success
  end

  test "should update user_schedule" do
    put :update, id: @user_schedule, user_schedule: @user_schedule.attributes
    assert_redirected_to user_schedule_path(assigns(:user_schedule))
  end

  test "should destroy user_schedule" do
    assert_difference('UserSchedule.count', -1) do
      delete :destroy, id: @user_schedule
    end

    assert_redirected_to user_schedules_path
  end
end
