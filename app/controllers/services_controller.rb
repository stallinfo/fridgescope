class ServicesController < ApplicationController
  before_action :logged_in_administrator
  before_action :set_service, only: %i[ show edit update destroy ]
  

  # GET /services or /services.json
  def index
    #@services = Service.paginate(page: params[:page])
    @services = Service.paginate(:page => params[:service_page], :per_page => 8)
  end

  # GET /services/1 or /services/1.json
  def show
    @service_managers = @service.service_managers.paginate(:page => params[:service_manager_page], :per_page => 10)
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services or /services.json
  def create
    @service = Service.new(service_params)
 
    @service.created_by = current_administrator.identify
    @service.update_count = 0
    @service.updated_by = current_administrator.identify

    respond_to do |format|
      if @service.save
        @services = Service.paginate(page: params[:page])
        flash[:success] = "Service created"
        format.html { render :index, notice: "Service was successfully created." }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    #respond_to do |format|
      @service.update_count = @service.update_count + 1
      @service.updated_by = current_administrator.identify
      if @service.update(service_params)
        #format.html { redirect_to @services, notice: "Service was successfully updated." }
        #format.json { render :show, status: :ok, location: @service }
        flash[:success] = "Service updated"
        redirect_to services_path
      else
        render 'edit'
        #format.html { render :edit, status: :unprocessable_entity }
        #format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    #end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully deleted." }
      format.json { head :no_content }
    end
  end
  
  def search 
    content = params[:words][:service_name]

    if content == nil || content == ""
      @services = Service.paginate(page: params[:page])
    else
      @services = Service.where("name LIKE ?","%"+content+"%").paginate(page: params[:page])
    end
    @content = content
    render 'index'
  end

  def confirmation
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(:name, :connection_phrase, :description, :update_count, :created_by, :updated_by)
    end

  
end
