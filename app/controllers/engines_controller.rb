class EnginesController < ApplicationController
  def edit_s
    @page_id = "engine"
    @config_page_id = "config"
    @user = current_user
  end
  
  def edit
    @page_id = "engine"
    @config_page_id = "config"
    #@user = current_user
    
    @engine_config = Hash.from_xml(current_user.engine_settings)['config']
    
    @atomic_engine_services = Hash.new
    services = AtomicEngineService.all
    services.each do |serv|
        if(@atomic_engine_services.key?(serv.service_class.capitalize))
          @atomic_engine_services[serv.service_class.capitalize] << serv
        else
          @atomic_engine_services[serv.service_class.capitalize] = Array.new
          @atomic_engine_services[serv.service_class.capitalize] << serv
        end
    end
    
    @smart_engine_services = Hash.new
    @smart_engine_services["All"] = Array.new
    services = SmartEngineService.all
    services.each do |serv|
          @smart_engine_services["All"] << serv
    end
  end
  
  def update_config
    user = current_user
    user.engine_settings = params[:engine_settings]
    if user.save
      redirect_to workflow_engine_settings_path
    else
      render :edit
    end
  end
  
  def show
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id] })#, :user_id => current_user.id })
    respond_to do |format|
      format.xml do
        @engine_service_xml = @engine_service.content
      end
    end
  end

  def run_engine_ssdl(smartservicegraph)
    @composition_service_name = Hash.from_xml(current_user.engine_settings)['init']['composition']
    @enginessdl = EngineUtils.xml_to_ssdl_struct(SmartEngineService.first(:conditions => { :name => @composition_service_name}))
    variable = SmartServiceInputVariable.new
    variable.name = 'ssdl'
    variable.type = 'SmartServiceGraph'
    variable.value = smartservicegraph
    @enginessdl.inputdata = Array.new
    @enginessdl.inputdata << variable
    
    smartservicegraph = EngineUtils.execute_smart_service(@enginessdl).value
    smartservicegraph.inputdata.each do |var|
      puts var.inspect
    end
    
    @result = EngineUtils.execute_smart_service(@enginessdl)
    render :layout => false
  end
  
end
