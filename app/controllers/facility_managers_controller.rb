class FacilityManagersController < ApplicationController
  #before_action :logged_in_facility_manager, only: [:index, :edit, :update, :destroy]
  before_action :logged_in_service_manager, only: [:index, :edit, :update, :destroy, :new]
  
  #before_action :correct_facility_manager,   only: [:edit, :update]
  
  def index
    @facility_managers = FacilityManager.paginate(page: params[:page])
  end

  def show 
    @facility_manager = FacilityManager.find(params[:id])
  end
  
  def new
    @facility_manager = FacilityManager.new
    @facility = Facility.find(params[:id])
  end

  def create
    @facility_manager = FacilityManager.new(facility_manager_params)
    @facility_manager.password_confirmation = @facility_manager.password
    @facility_manager.created_by = current_service_manager.identify
    @facility_manager.updated_by = current_service_manager.identify
    @facility_manager.update_count = 0
    @facility = Facility.find(@facility_manager.facility_id)
    if @facility_manager.save
      facility_manager_log_in @facility_manager
      flash[:success] = "Welcome to the Fridge scope app!"
      redirect_to @facility
    else
      render 'new'
    end 
  end
  
  def edit
    @facility_manager = FacilityManager.find(params[:id])
    @facility = Facility.find(@facility_manager.facility_id)
  end

  def update
    @facility_manager = FacilityManager.find(params[:id])
    @facility_manager.password_confirmation = @facility_manager.password
    @facility_manager.update_count += 1
    @facility_manager.updated_by = current_service_manager.identify
    @facility = Facility.find(@facility_manager.facility_id)
    if @facility_manager.update(facility_manager_params)
      flash[:success] = "Facility manager updated"
      redirect_to @facility
    else
      render 'edit'
    end
  end

  def destroy
    #FacilityManager.find(params[:id]).destroy
    #flash[:success] = "Facility manager deleted"
    #redirect_to facility_managers_url
    @facility_manager = FacilityManager.find(params[:id])
    @facility = Facility.find(@facility_manager.facility_id)
    @facility_manager.destroy
    flash[:success] = "Service manager deleted"
    redirect_to @facility
  end

  private
    def facility_manager_params
        params.require(:facility_manager).permit(:name, :identify, :email, :password, :password_confirmation, :facility_id)
    end
    
    def correct_facility_manager
      @facility_manager = FacilityManager.find(params[:id]) 
      redirect_to(facility_manager_login_path) unless current_facility_manager?(@facility_manager)
    end

  
end
