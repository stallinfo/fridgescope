class ServiceManagersController < ApplicationController
  #before_action :logged_in_service_manager, only: [:index, :edit, :update, :destroy]
  #before_action :correct_service_manager,   only: [:edit, :update]
  before_action :logged_in_administrator, only: [:index, :edit, :update, :destroy]
  #before_action :correct_administrator,   only: [:edit, :update]

  def index
    @service_managers = ServiceManager.paginate(page: params[:page])
  end

  def show
    @service_manager = ServiceManager.find(params[:id])
  end

  def new
    @service_manager = ServiceManager.new
    @service = Service.find(params[:id])
  end

  def create
    @service_manager = ServiceManager.new(service_manager_params)
    @service_manager.password_confirmation = @service_manager.password
    @service = Service.find(@service_manager.service_id)
    @service_manager.created_by = current_administrator.identify
    
    @service_manager.update_count = 0
    if @service_manager.save
      service_manager_log_in @service_manager
      flash[:success] = "Welcome to the Fridge scope app!"
      redirect_to @service
    else
      render 'new'
    end 
  end

  def edit
    @service_manager = ServiceManager.find(params[:id])
    @service = Service.find(@service_manager.service_id)
  end

  def update
    @service_manager = ServiceManager.find(params[:id])
    @service_manager.password_confirmation = @service_manager.password
    @service = Service.find(@service_manager.service_id)
    @service_manager.update_count += 1
    @service_manager.updated_by = current_administrator.identify
    if @service_manager.update(service_manager_params)
      flash[:success] = "Service manager updated"
      redirect_to @service
    else
      render 'edit'
    end
  end

  def destroy
    @service_manager = ServiceManager.find(params[:id])
    @service = Service.find(@service_manager.service_id)
    @service_manager.destroy
    flash[:success] = "Service manager deleted"
    redirect_to @service
  end

  private
    def service_manager_params
        params.require(:service_manager).permit(:name, :identify, :password, :password_confirmation, :connection, :service_id)
    end

    def correct_service_manager
      @service_manager = ServiceManager.find(params[:id]) 
      redirect_to(service_manager_login_path) unless current_service_manager?(@service_manager)
    end
end
