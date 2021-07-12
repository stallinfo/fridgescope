require "test_helper"

class FacilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @facility = facilities(:one)
  end

  test "should get index" do
    get facilities_url
    assert_response :success
  end

  test "should get new" do
    get new_facility_url
    assert_response :success
  end

  test "should create facility" do
    assert_difference('Facility.count') do
      post facilities_url, params: { facility: { created_api_caller: @facility.created_api_caller, created_by: @facility.created_by, latitude: @facility.latitude, longitude: @facility.longitude, name: @facility.name, service_id: @facility.service_id, update_count: @facility.update_count, updated_api_caller: @facility.updated_api_caller, updated_by: @facility.updated_by } }
    end

    assert_redirected_to facility_url(Facility.last)
  end

  test "should show facility" do
    get facility_url(@facility)
    assert_response :success
  end

  test "should get edit" do
    get edit_facility_url(@facility)
    assert_response :success
  end

  test "should update facility" do
    patch facility_url(@facility), params: { facility: { created_api_caller: @facility.created_api_caller, created_by: @facility.created_by, latitude: @facility.latitude, longitude: @facility.longitude, name: @facility.name, service_id: @facility.service_id, update_count: @facility.update_count, updated_api_caller: @facility.updated_api_caller, updated_by: @facility.updated_by } }
    assert_redirected_to facility_url(@facility)
  end

  test "should destroy facility" do
    assert_difference('Facility.count', -1) do
      delete facility_url(@facility)
    end

    assert_redirected_to facilities_url
  end
end
