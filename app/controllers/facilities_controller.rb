class FacilitiesController < ApplicationController
  before_action :set_facility, only: %i[ show edit update destroy ]
  before_action :logged_in_service_manager, only: [:index, :edit, :update, :destroy]

  # GET /facilities or /facilities.json
  def index
    @facilities = Facility.paginate(:page => params[:facility_page], :per_page => 10)
  end

  # GET /facilities/1 or /facilities/1.json
  def show
    @facility_managers = @facility.facility_managers.paginate(:page => params[:facility_manager_page], :per_page => 10)
  end

  # GET /facilities/new
  def new
    @googleapikey = ENV['GOOGLE_API_KEY']
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
    @googleapikey = ENV['GOOGLE_API_KEY']
  end

  # POST /facilities or /facilities.json
  def create
    @facility = Facility.new(facility_params)
    service = Service.find(current_service_manager.service_id)
    @facility.service_id = service.id
    @facility.created_by = current_service_manager.identify
    @facility.update_count = 0
    @facility.updated_by = current_service_manager.identify
    respond_to do |format|
      if @facility.save
        format.html { redirect_to facilities_path, notice: "Facility was successfully created." }
        format.json { render :show, status: :created, location: @facility }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facilities/1 or /facilities/1.json
  def update
    @facility.update_count += 1
    @facility.updated_by = current_service_manager.identify
    
    respond_to do |format|
      if @facility.update(facility_params)
        format.html { redirect_to facilities_path, notice: "Facility was successfully updated." }
        format.json { render :show, status: :ok, location: @facility }
       
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facilities/1 or /facilities/1.json
  def destroy
    @facility.destroy
    respond_to do |format|
      format.html { redirect_to facilities_url, notice: "Facility was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    if params[:words]!= nil
      content = params[:words][:facility_name]
    end
    if content == nil || content == ""
      @facilities = Facility.paginate(page: params[:page])
    else
      @facilities = Facility.where("name LIKE ?","%"+content+"%").paginate(page: params[:page])
    end
    @content = content
    render 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def facility_params
      params.require(:facility).permit(:service_id, :name, :latitude, :longitude, :update_count, :created_by, :created_api_caller, :updated_by, :updated_api_caller)
    end
end
