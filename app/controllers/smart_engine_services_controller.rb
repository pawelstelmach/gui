class SmartEngineServicesController < ApplicationController
  def index
    @page_id = "engine"
    @config_page_id = "services"
    @engine_services = SmartEngineService.all(:conditions => { :user_id => current_user.id })
  end
  
  def new_old
        @page_id = "engine"
    @config_page_id = "services"
    #settings = Settings.first
    @engine_service = SmartEngineService.new
  end

  def create_old
    @engine_service = SmartEngineService.new(params[:smart_engine_service])
    @engine_service.user_id=current_user.id
    if @engine_service.save
      redirect_to smart_engine_services_path
    else
      render :action => 'new'
    end
  end

  def edit
        @page_id = "engine"
    @config_page_id = "services"
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id], :user_id => current_user.id })
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
    @page_id = "engine"
    @config_page_id = "services"
    @engine_service = SmartEngineService.first(:conditions => { :id => params[:id] })#, :user_id => current_user.id })
   respond_to do |format|
      #format.html
      format.xml do
        @engine_service_xml = @engine_service.content
      end
    end
  end
  
  def new
    @page_id = "engine"
    @config_page_id = "services"
    @atomic_services = Hash.new
    services = AtomicEngineService.all
    services.each do |serv|
        if(@atomic_services.key?(serv.service_class.capitalize))
          @atomic_services[serv.service_class.capitalize] << serv
        else
          @atomic_services[serv.service_class.capitalize] = Array.new
          @atomic_services[serv.service_class.capitalize] << serv
        end
    end
    @nodes = Array.new
    @action = 'editor_create'
  end
  
    def edit
    @page_id = "engine"
    @config_page_id = "services"
    @atomic_services = Hash.new
    services = AtomicEngineService.all
    services.each do |serv|
        if(@atomic_services.key?(serv.service_class.capitalize))
          @atomic_services[serv.service_class.capitalize] << serv
        else
          @atomic_services[serv.service_class.capitalize] = Array.new
          @atomic_services[serv.service_class.capitalize] << serv
        end
    end
    
    engine_service = SmartEngineService.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    nodes_temp = EngineUtils.xml_to_ssdl_struct(engine_service.content).nodes
    nodes_temp.delete_if do |n| n.nodeclass=="#start" || n.nodeclass=="#end" end
    
    @nodes = Array.new
    nodes_temp.each do |n|
      @nodes << {:name => n.name, :id => AtomicEngineService.first(:conditions => { :name => n.name}).id}
    end
    @name = engine_service.name
    @description = ""#engine_service.description
    @action = 'editor_update'
  end
  
  def editor_create
        services_ids = params[:services]
        
        ssdl = generate_ssdl(services_ids)
        
        engine_service = SmartEngineService.new
        engine_service.content = EngineUtils.ssdl_struct_to_xml(ssdl)
        engine_service.name = params[:name]
        engine_service.user_id=current_user.id
        if engine_service.save
          redirect_to smart_engine_services_path
        else
          render :action => 'edit'
        end
    end
    
    def editor_update
        services_ids = params[:services]
        
        ssdl = generate_ssdl(services_ids)
        
        engine_service = SmartEngineService.find(params[:id])
        engine_service.content = EngineUtils.ssdl_struct_to_xml(ssdl)
        engine_service.name = params[:name]
        engine_service.user_id=current_user.id
        if engine_service.save
          redirect_to smart_engine_services_path
        else
          render :action => 'edit'
        end
    end

    private
    def generate_ssdl(services_ids)
      
        nodes = Array.new
        
        start_node = SmartServiceNode.new
        
        start_node.name = "start"
        start_node.nodeclass = "#start"
        start_node.nodetype = "Control"
        start_node.controltype = "Start"
        start_node.inputs = Array.new
        
        index = 0
        input = SmartServiceInput.new
        input.metaname = "ssdl"
        input.name = "ssdl"+index.to_s
        input.type = "SmartServiceGraph"
        
        start_node.inputs << input
        
        start_node.outputs = Array.new
        
        output = SmartServiceOutput.new
        output.metaname = "ssdl"
        output.name = "ssdl"+index.to_s
        output.type = "SmartServiceGraph"
        
        start_node.outputs << output
        
        nodes << start_node
        
        services_ids.each do |id|
          service = AtomicEngineService.find(id)
          node = SmartServiceNode.new
          node.name = service.name
          node.nodeclass = service.service_class
          node.nodetype = "Service"
          node.address = service.address
          node.method = service.method
          
          node.inputs = Array.new
          
          input = SmartServiceInput.new
          input.metaname = "ssdl"
          input.name = "ssdl"+index.to_s
          input.type = "SmartServiceGraph"
          input.source = nodes.last.name
          
          node.inputs << input
          
          node.outputs = Array.new
          
          output = SmartServiceOutput.new
          output.metaname = "ssdl"
          output.name = "ssdl"+(index+1).to_s
          output.type = "SmartServiceGraph"
          
          node.outputs << output
          
          nodes << node
          
          index = index + 1
        end
        
        end_node = SmartServiceNode.new
        
        end_node.name = "end"
        end_node.nodeclass = "#end"
        end_node.nodetype = "Control"
        end_node.controltype = "End"
        end_node.inputs = Array.new
        
        input = SmartServiceInput.new
        input.metaname = "ssdl"
        input.name = "ssdl"+index.to_s
        input.type = "SmartServiceGraph"
        input.source = nodes.last.name
        
        end_node.inputs << input
        
        end_node.outputs = Array.new
        
        output = SmartServiceOutput.new
        output.metaname = "ssdl"
        output.name = "ssdl"+index.to_s
        output.type = "SmartServiceGraph"
        
        end_node.outputs << output
        
        nodes << end_node
        
        ssdl = SmartServiceGraph.new
        ssdl.nodes = nodes
        return ssdl
    end
end
