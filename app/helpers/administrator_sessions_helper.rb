module AdministratorSessionsHelper

    #Logs in the given administrator
    def administrator_log_in(administrator)
        session[:administrator_id] = administrator.id
    end 
    
    def administrator_remember(administrator)
        administrator.remember
        cookies.permanent.signed[:administrator_id] = administrator.id 
        cookies.permanent[:remember_token] = administrator.remember_token
    end

    # Returns the current logged-in administrator (if any).
    def current_administrator
        if (administrator_id = session[:administrator_id])
            @current_administrator ||= Administrator.find_by(id: session[:administrator_id])
        elsif (administrator_id = cookies.signed[:administrator_id])
            administrator = Administrator.find_by(id: administrator_id)
            if administrator && administrator.authenticated?(cookies[:remember_token])
                administrator_log_in administrator
                @current_administrator = administrator 
            end
        end
    end
    
    def current_administrator?(administrator)
        administrator && administrator == current_administrator
    end

    def administrator_logged_in?
        !current_administrator.nil?
    end


    def administrator_forget(administrator)
        administrator.forget
        cookies.delete(:administrator_id)
        cookies.delete(:remember_token)
    end

    def administrator_log_out
        administrator_forget(current_administrator)
        session.delete(:administrator_id)
        @current_administrator = nil 
    end

    def administrator_redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
      
    def administrator_store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
