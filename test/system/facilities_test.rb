require "application_system_test_case"

class FacilitiesTest < ApplicationSystemTestCase
  setup do
    @facility = facilities(:one)
  end

  test "visiting the index" do
    visit facilities_url
    assert_selector "h1", text: "Facilities"
  end

  test "creating a Facility" do
    visit facilities_url
    click_on "New Facility"

    fill_in "Created api caller", with: @facility.created_api_caller
    fill_in "Created by", with: @facility.created_by
    fill_in "Latitude", with: @facility.latitude
    fill_in "Longitude", with: @facility.longitude
    fill_in "Name", with: @facility.name
    fill_in "Service", with: @facility.service_id
    fill_in "Update count", with: @facility.update_count
    fill_in "Updated api caller", with: @facility.updated_api_caller
    fill_in "Updated by", with: @facility.updated_by
    click_on "Create Facility"

    assert_text "Facility was successfully created"
    click_on "Back"
  end

  test "updating a Facility" do
    visit facilities_url
    click_on "Edit", match: :first

    fill_in "Created api caller", with: @facility.created_api_caller
    fill_in "Created by", with: @facility.created_by
    fill_in "Latitude", with: @facility.latitude
    fill_in "Longitude", with: @facility.longitude
    fill_in "Name", with: @facility.name
    fill_in "Service", with: @facility.service_id
    fill_in "Update count", with: @facility.update_count
    fill_in "Updated api caller", with: @facility.updated_api_caller
    fill_in "Updated by", with: @facility.updated_by
    click_on "Update Facility"

    assert_text "Facility was successfully updated"
    click_on "Back"
  end

  test "destroying a Facility" do
    visit facilities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Facility was successfully destroyed"
  end
end
