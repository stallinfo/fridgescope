module ServiceManagerSessionsHelper
    def service_manager_log_in(service_manager)
        session[:service_manager_id] = service_manager.id
    end 

    def service_manager_remember(service_manager)
        service_manager.remember
        cookies.permanent.signed[:service_manager_id] = service_manager.id 
        cookies.permanent[:remember_token] = service_manager.remember_token
    end

    # Returns the current logged-in service manager (if any).
    def current_service_manager
        if (service_manager_id = session[:service_manager_id])
            @current_service_manager ||= ServiceManager.find_by(id: session[:service_manager_id])
        elsif (service_manager_id = cookies.signed[:service_manager_id])
            service_manager = ServiceManager.find_by(id: service_manager_id)
            if service_manager && service_manager.authenticated?(cookies[:remember_token])
                service_manager_log_in service_manager
                @current_service_manager = service_manager 
            end
        end
    end

    def current_service_manager?(service_manager)
        service_manager && service_manager == current_service_manager
    end

    def service_manager_logged_in?
        !current_service_manager.nil?
    end

    def service_manager_forget(service_manager)
        service_manager.forget
        cookies.delete(:service_manager_id)
        cookies.delete(:remember_token)
    end

    def service_manager_log_out
        service_manager_forget(current_service_manager)
        session.delete(:service_manager_id)
        @current_service_manager = nil 
    end
    
    def service_manager_redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
      
    def service_manager_store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
end
