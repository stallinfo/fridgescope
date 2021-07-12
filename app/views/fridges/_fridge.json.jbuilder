json.extract! fridge, :id, :facility_id, :name, :description, :latitude, :longitude, :update_count, :created_by, :created_api_caller, :updated_by, :updated_api_caller, :created_at, :updated_at
json.url fridge_url(fridge, format: :json)
