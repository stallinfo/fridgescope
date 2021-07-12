class FacilityManagerSessionsController < ApplicationController
  def new
  end
  
  def create
    facility_manager = FacilityManager.find_by(identify: params[:facility_manager_session][:identify])
    if facility_manager && facility_manager.authenticate(params[:facility_manager_session][:password])
      facility_manager_log_in facility_manager 
      params[:facility_manager_session][:remember_me] == '1' ? facility_manager_remember(facility_manager) : facility_manager_forget(facility_manager)
      facility_manager_redirect_back_or facility_manager
    else
      flash[:danger] = 'Invalid identify/password combination'
      render 'new'
    end
  end

  def destroy
    facility_manager_log_out if facility_manager_logged_in?
    redirect_to facility_manager_login_path
  end

end
