class AdministratorsController < ApplicationController
  before_action :logged_in_administrator, only: [:index, :edit, :update, :destroy]
  before_action :correct_administrator,   only: [:edit, :update]
  
  def index
    @administrators = Administrator.paginate(page: params[:page])
  end
  
  def show
    @administrator = Administrator.find(params[:id])
  end
  
  def new
    @administrator = Administrator.new
  end

  def create
    @administrator = Administrator.new(administrator_params)
    @administrator.password_confirmation = @administrator.password
    if @administrator.save
      administrator_log_in @administrator
      flash[:success] = "Welcome to the Fridge scope app!"
      redirect_to @administrator
    else
      render 'new'
    end 
  end

  def edit
    @administrator = Administrator.find(params[:id])
  end

  def update
    @administrator = Administrator.find(params[:id])
    @administrator.password_confirmation = @administrator.password
    if @administrator.update(administrator_params)
      flash[:success] = "Administrator updated"
      redirect_to @administrator
    else
      render 'edit'
    end
  end
  
  def destroy
    Administrator.find(params[:id]).destroy
    flash[:success] = "Administrator deleted"
    redirect_to administrators_url
  end

  private
    def administrator_params
        params.require(:administrator).permit(:name, :identify, :password, :password_confirmation)
    end
    
    def correct_administrator
      @administrator = Administrator.find(params[:id])
      redirect_to(administrator_login_path) unless current_administrator?(@administrator)
    end
end
