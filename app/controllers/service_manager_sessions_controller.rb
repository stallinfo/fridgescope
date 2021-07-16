class ServiceManagerSessionsController < ApplicationController
  def new
  end
  
  def create
    service_manager = ServiceManager.find_by(identify: params[:service_manager_session][:identify])
    
    if service_manager != nil
      service = Service.find(service_manager.service_id)
    end

    if service_manager && service_manager.authenticate(params[:service_manager_session][:password]) && service.connection_phrase == params[:service_manager_session][:connection_phrase]
      service_manager_log_in service_manager
      params[:service_manager_session][:remember_me] == '1' ? service_manager_remember(service_manager) : service_manager_forget(service_manager)
      #service_manager_redirect_back_or service_manager
      redirect_to facilities_path(:id => service_manager.id)
    else
      flash[:danger] = 'Invalid identify/password combination'
      render 'new'
    end
  end

  def destroy
    service_manager_log_out if service_manager_logged_in?
    redirect_to service_manager_login_path
  end


end
