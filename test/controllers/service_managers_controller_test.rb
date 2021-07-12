require "test_helper"

class ServiceManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get service_managers_new_url
    assert_response :success
  end
end
