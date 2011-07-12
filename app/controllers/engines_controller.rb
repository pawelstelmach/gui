class EnginesController < ApplicationController
  def edit
    @page_id = "config"
    @user = current_user
    render :layout => 'config'
  end
  
  def update
    @user = current_user
    puts params
    if @user.update_attributes(params[:user])
      redirect_to engines_path
    else
      render :edit
    end
  end
  
  def show
    @page_id = "selected_experiment"
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
