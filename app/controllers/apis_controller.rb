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

            if facility != nil && facility.service_id == service.id
                jsonMsg(200,"Authenticated",[service.name, service.description]) 
            else
                jsonMsg(500,"Rejected",[]) 
            end
        else
            jsonMsg(500,"Rejected",[])
        end
    end

    def register
    
    end

    def upload
        image = params[:image]
        title = params[:title]
        Fridge.create(name: "test upload", initial_picture_path: image, description: title, facility_id: 1, latitude: 34.96044797500092, longitude: 138.4044472577484, update_count: 0)
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
