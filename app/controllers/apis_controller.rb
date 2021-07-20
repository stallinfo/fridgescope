class ApisController < ApplicationController
    #protect_from_forgery except: :profile
    skip_before_action :verify_authenticity_token
    include Rails.application.routes.url_helpers

    def login
        connection_phrase = params[:connection_phrase]
        identify = params[:identify]
        password = params[:password]
        full_name = params[:full_name]
        email = params[:email]
        service = Service.find_by(connection_phrase: connection_phrase)
        facility_manager = FacilityManager.find_by(identify: identify)
        
        if facility_manager != nil && service != nil
            facility = Facility.find(facility_manager.facility_id)

            if facility != nil && facility.service_id == service.id && facility_manager.authenticate(password)
                jsonMsg(200,"Authenticated",[service.name, service.description]) 
                if facility_manager.email == nil || facility_manager.email == ""
                    facility_manager.update(email: email)
                end
            else
                jsonMsg(500,"Rejected",[]) 
            end
        else
            jsonMsg(500,"Rejected",[])
        end
    end

    def lightlogin
        identify = params[:identify]
        password = params[:password]
        facility_manager = FacilityManager.find_by(identify: identify)
        if facility_manager != nil && facility_manager.authenticate(password)
            jsonMsg(200,"Authenticated",[]) 
        else
            jsonMsg(500,"Authentication failed",[]) 
        end
    end

    def upload
        image = params[:image]
        title = params[:title]
        identify = params[:identify]
        password = params[:password]
        latitude = params[:latitude].to_f
        longitude = params[:longitude].to_f
        fridge_id = params[:fridge_id].to_i
        facility_manager = FacilityManager.find_by(identify: identify)
        initial_storage_rate = 0
        if facility_manager.authenticate(password)
            facility = Facility.find(facility_manager.facility_id)
            initial_storage_rate = density_calculation(image)
            if fridge_id == -1 
                Fridge.create(name: title, initial_picture_path: image, description: "", facility_id: facility.id, latitude: latitude, longitude: longitude, update_count: 0, initial_storage_rate: initial_storage_rate)
            else
                fridge = Fridge.find(fridge_id)
                if fridge.fridge_latest_states.count > 0
                    fridge_last = fridge.fridge_latest_states.first
                    update_count = fridge_last.update_count + 1
                    fridge_last.update_attributes(current_picture_path: image, current_storage_rate: initial_storage_rate, update_count: update_count, updated_by: facility_manager.identify)
                else
                    FridgeLatestState.create(current_picture_path: image, fridge_id: fridge_id, update_count: 0, created_by: facility_manager.identify, current_storage_rate: initial_storage_rate)
                end
                FridgePastState.create(current_picture_path: image, fridge_id: fridge_id, update_count: 0, created_by: facility_manager.identify, current_storage_rate: initial_storage_rate)
            end
        end
        render json: {result: initial_storage_rate}
    end

    def retrieve_facilities
        facilities = Facility.all
        facs = [] 
        facs_count = 0
        facilities.each do | facility |
            facs[facs_count] = {}
            facs[facs_count]["name"] = facility.name
            facs[facs_count]["lat"] = facility.latitude
            facs[facs_count]["lon"] = facility.longitude
            facs[facs_count]["id"] = facility.id
            facs[facs_count]["rate"] = 100
            fridges = []
            fridge_count = 0
            if facility.fridges.count > 0
                facility.fridges.each do | fridge |
                    fridges[fridge_count] = {}
                    fridges[fridge_count]["id"] = fridge.id
                    fridges[fridge_count]["name"] = fridge.name
                    fridges[fridge_count]["description"] = fridge.description
                    fridges[fridge_count]["lat"] = fridge.latitude
                    fridges[fridge_count]["lon"] = fridge.longitude
                    fridges[fridge_count]["date"] = fridge.updated_at
                    fridges[fridge_count]["rate"] = fridge.initial_storage_rate.to_i
                    if fridge.fridge_latest_states.count == 0
                        if fridge.initial_storage_rate != nil && facs[facs_count]["rate"] > fridge.initial_storage_rate.to_i
                            facs[facs_count]["rate"] = fridge.initial_storage_rate.to_i
                        end
                        if fridge.initial_picture_path.attached?
                            fridges[fridge_count]["image"] = rails_blob_path(fridge.initial_picture_path , only_path: true)
                        else
                            fridges[fridge_count]["image"] = "Homer Simpson"
                        end
                    else
                        fridge_last = fridge.fridge_latest_states.first
                        if fridge_last.current_storage_rate != nil && facs[facs_count]["rate"] > fridge_last.current_storage_rate.to_i
                            facs[facs_count]["rate"] = fridge_last.current_storage_rate.to_i
                        end
                        if fridge_last.current_picture_path.attached?
                            fridges[fridge_count]["image"] = rails_blob_path(fridge_last.current_picture_path , only_path: true)
                        else
                            fridges[fridge_count]["image"] = "Homer Simpson"
                        end
                        fridges[fridge_count]["rate"] = fridge_last.current_storage_rate.to_i
                    end
                    fridge_count += 1
                end
            end
            facs[facs_count]["fridges"] = fridges
            facs_count += 1
        end
        jsonString = {facilities: facs}
        render json: jsonString.to_json
    end

    def retrieve_fridges
    
        identify = params[:identify] #facility manager
        password = params[:password] #facility manager
        facility_manager = FacilityManager.find_by(identify: identify)
        if facility_manager && facility_manager.authenticate(password)
            fac = {}
            fac["name"] = facility_manager.facility.name
            fac["lat"] = facility_manager.facility.latitude
            fac["lon"] = facility_manager.facility.longitude
            fac["id"] = facility_manager.facility.id
            fac["rate"] = 100
            fridges = []
            fridge_count = 0
            if facility_manager.facility.fridges.count > 0
                facility_manager.facility.fridges.each do | fridge |
                    fridges[fridge_count] = {}
                    fridges[fridge_count]["id"] = fridge.id
                    fridges[fridge_count]["name"] = fridge.name
                    fridges[fridge_count]["description"] = fridge.description
                    fridges[fridge_count]["lat"] = fridge.latitude
                    fridges[fridge_count]["lon"] = fridge.longitude
                    fridges[fridge_count]["date"] = fridge.updated_at
                    fridges[fridge_count]["rate"] = fridge.initial_storage_rate.to_i
                    if fridge.fridge_latest_states.count == 0
                        if fac["rate"] > fridge.initial_storage_rate.to_i
                            fac["rate"] = fridge.initial_storage_rate.to_i
                        end
                        if fridge.initial_picture_path.attached?
                            fridges[fridge_count]["image"] = rails_blob_path(fridge.initial_picture_path , only_path: true)
                        else
                            fridges[fridge_count]["image"] = "Homer Simpson"
                        end
                    else
                        fridge_last = fridge.fridge_latest_states.first
                        if fac["rate"] > fridge_last.current_storage_rate.to_i
                            fac["rate"] = fridge_last.current_storage_rate.to_i
                        end
                        if fridge_last.current_picture_path.attached?
                            fridges[fridge_count]["image"] = rails_blob_path(fridge_last.current_picture_path , only_path: true)
                        else
                            fridges[fridge_count]["image"] = "Homer Simpson"
                        end
                        fridges[fridge_count]["rate"] = fridge_last.current_storage_rate.to_i
                    end
                    fridge_count += 1
                end
            end
            fac["fridges"] = fridges
            jsonString = {facility: fac}
            render json: jsonString.to_json
        else
            jsonMsg(500,"Rejected",[])
        end

    end
    
    def get_fridge
        identify = params[:identify]
        password = params[:password]
        facility_manager = FacilityManager.find_by(identify: identify)
        fridge_id = params[:fridge_id].to_i
        if facility_manager && facility_manager.authenticate(password)
            fridge = Fridge.find(fridge_id)
            if fridge.fridge_latest_states.count == 0
                rate = fridge.initial_storage_rate
            else
                rate = fridge.fridge_latest_states.first.current_storage_rate
            end
            jsonMsg(200,"accepted",[rate])
        else
            jsonMsg(500,"Rejected",[])
        end
    end

    private 
        def jsonMsg(errNum, errMessage, results)
            responseInfo = {status: errNum, developerMessage: errMessage}
            metadata = {responseInfo: responseInfo}
            jsonString = {metadata: metadata, results: results}
            render json: jsonString.to_json
        end

end
