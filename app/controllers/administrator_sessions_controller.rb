class AdministratorSessionsController < ApplicationController
  def new
  end
  
  def create
    administrator = Administrator.find_by(identify: params[:administrator_session][:identify])
    if administrator && administrator.authenticate(params[:administrator_session][:password])
      administrator_log_in administrator 
      params[:administrator_session][:remember_me] == '1' ? administrator_remember(administrator) : administrator_forget(administrator)
      #administrator_redirect_back_or services_path
      redirect_to services_path
    else
      errorMessage = ""
      if params[:administrator_session][:identify].length == 0
        errorMessage = "ID not entered\n"
      end
      if params[:administrator_session][:password].length == 0
        errorMessage += "Password not entered"
      end
      if errorMessage == ""
        errorMessage = "Invalid identify/password combination"
      end
      flash[:danger] = errorMessage #'Invalid identify/password combination'
      render 'new'
    end
  end

  def destroy
    administrator_log_out if administrator_logged_in?
    redirect_to administrator_login_path
  end



end
