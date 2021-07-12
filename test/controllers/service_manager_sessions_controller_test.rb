require "test_helper"

class ServiceManagerSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get service_manager_sessions_new_url
    assert_response :success
  end
end
