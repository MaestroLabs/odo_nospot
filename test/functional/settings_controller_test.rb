require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get settingspage" do
    get :settingspage
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get changepassword" do
    get :changepassword
    assert_response :success
  end

end
