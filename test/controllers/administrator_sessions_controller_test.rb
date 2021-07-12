require "test_helper"

class AdministratorSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get administrator_sessions_new_url
    assert_response :success
  end
end
