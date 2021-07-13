class ApplicationController < ActionController::Base
    include AdministratorSessionsHelper
    include FacilityManagerSessionsHelper
    include ServiceManagerSessionsHelper
    include ApplicationHelper
    
    private

        def logged_in_administrator
            unless administrator_logged_in?
                administrator_store_location
                flash[:danger] = "Please log in"
                redirect_to administrator_login_path
            end
        end
        
        def logged_in_facility_manager
            unless facility_manager_logged_in?
                facility_manager_store_location
                flash[:danger] = "Please log in"
                redirect_to facility_manager_login_path
            end
        end
        
        def logged_in_service_manager
            unless service_manager_logged_in?
              service_manager_store_location
              flash[:danger] = "Please log in"
              redirect_to service_manager_login_path
            end
        end
end
