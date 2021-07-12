require "test_helper"

class FacilityManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get facility_managers_new_url
    assert_response :success
  end
end
