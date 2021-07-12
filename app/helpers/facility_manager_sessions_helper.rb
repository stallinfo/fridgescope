module FacilityManagerSessionsHelper
    def facility_manager_log_in(facility_manager)
        session[:facility_manager_id] = facility_manager.id
    end 
    
    def facility_manager_remember(facility_manager)
        facility_manager.remember
        cookies.permanent.signed[:facility_manager_id] = facility_manager.id 
        cookies.permanent[:remember_token] = facility_manager.remember_token
    end

    # Returns the current logged-in facility manager (if any).
    def current_facility_manager
        if (facility_manager_id = session[:facility_manager_id])
            @current_facility_manager ||= FacilityManager.find_by(id: session[:facility_manager_id])
        elsif (facility_manager_id = cookies.signed[:facility_manager_id])
            facility_manager = FacilityManager.find_by(id: facility_manager_id)
            if facility_manager && facility_manager.authenticated?(cookies[:remember_token])
                facility_manager_log_in facility_manager
                @current_facility_manager = facility_manager 
            end
        end
    end

    def current_facility_manager?(facility_manager)
        facility_manager && facility_manager == current_facility_manager
    end

    def facility_manager_logged_in?
        !current_facility_manager.nil?
    end

    def facility_manager_forget(facility_manager)
        facility_manager.forget
        cookies.delete(:facility_manager_id)
        cookies.delete(:remember_token)
    end
    
    def facility_manager_log_out
        facility_manager_forget(current_facility_manager)
        session.delete(:facility_manager_id)
        @current_facility_manager = nil 
    end
    
    def facility_manager_redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
      
    def facility_manager_store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
