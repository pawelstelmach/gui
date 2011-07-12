class SmartEngineServicesController < ApplicationController
  def index
    @page_id = "services"
    @engine_services = SmartEngineService.all(:conditions => { :user_id => current_user.id })
    render :layout => 'config'
  end
  
  def new
    @page_id = "services" 
    #settings = Settings.first
    @engine_service = SmartEngineService.new
    render :layout => 'config'
  end

  def create
    @engine_service = SmartEngineService.new(params[:smart_engine_service])
    @engine_service.user_id=current_user.id
    if @engine_service.save
      redirect_to smart_engine_services_path
    else
      render :action => 'new'
    end
  end

  def edit
    @page_id = "services"
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    render :layout => 'config'
  end

  def update
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    @engine_service.user_id=current_user.id
    if @engine_service.update_attributes(params[:smart_engine_service]) #&& @experiment.update_attributes(:algorytm_doboru_uslug => Settings.first.algorytm_doboru_uslug)
      redirect_to smart_engine_services_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    @engine_service.destroy
    redirect_to smart_engine_services_path
  end
  
  def show
    @page_id = "services"
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id] })#, :user_id => current_user.id })
   respond_to do |format|
      #format.html
      format.xml do
        @engine_service_xml = @engine_service.content
      end
    end
  end

end
