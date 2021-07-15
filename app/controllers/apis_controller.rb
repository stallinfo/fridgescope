class ApisController < ApplicationController
    #protect_from_forgery except: :profile
    skip_before_action :verify_authenticity_token

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
        facility_manager = FacilityManager.find_by(identify: identify)
        if facility_manager.authenticate(password)
            facility = Facility.find(facility_manager.facility_id)
            initial_storage_rate = density_calculation(image)
            Fridge.create(name: title, initial_picture_path: image, description: "", facility_id: facility.id, latitude: latitude, longitude: longitude, update_count: 0, initial_storage_rate: initial_storage_rate)
        end
        render json: {result: 0}
    end

    private 
        def jsonMsg(errNum, errMessage, results)
            responseInfo = {status: errNum, developerMessage: errMessage}
            metadata = {responseInfo: responseInfo}
            jsonString = {metadata: metadata, results: results}
            render json: jsonString.to_json
        end

end
