require "test_helper"

class FacilityManagerSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get facility_manager_sessions_new_url
    assert_response :success
  end
end
