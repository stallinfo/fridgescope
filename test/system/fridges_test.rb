require "application_system_test_case"

class FridgesTest < ApplicationSystemTestCase
  setup do
    @fridge = fridges(:one)
  end

  test "visiting the index" do
    visit fridges_url
    assert_selector "h1", text: "Fridges"
  end

  test "creating a Fridge" do
    visit fridges_url
    click_on "New Fridge"

    fill_in "Created api caller", with: @fridge.created_api_caller
    fill_in "Created by", with: @fridge.created_by
    fill_in "Description", with: @fridge.description
    fill_in "Facility", with: @fridge.facility_id
    fill_in "Latitude", with: @fridge.latitude
    fill_in "Longitude", with: @fridge.longitude
    fill_in "Name", with: @fridge.name
    fill_in "Update count", with: @fridge.update_count
    fill_in "Updated api caller", with: @fridge.updated_api_caller
    fill_in "Updated by", with: @fridge.updated_by
    click_on "Create Fridge"

    assert_text "Fridge was successfully created"
    click_on "Back"
  end

  test "updating a Fridge" do
    visit fridges_url
    click_on "Edit", match: :first

    fill_in "Created api caller", with: @fridge.created_api_caller
    fill_in "Created by", with: @fridge.created_by
    fill_in "Description", with: @fridge.description
    fill_in "Facility", with: @fridge.facility_id
    fill_in "Latitude", with: @fridge.latitude
    fill_in "Longitude", with: @fridge.longitude
    fill_in "Name", with: @fridge.name
    fill_in "Update count", with: @fridge.update_count
    fill_in "Updated api caller", with: @fridge.updated_api_caller
    fill_in "Updated by", with: @fridge.updated_by
    click_on "Update Fridge"

    assert_text "Fridge was successfully updated"
    click_on "Back"
  end

  test "destroying a Fridge" do
    visit fridges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fridge was successfully destroyed"
  end
end
