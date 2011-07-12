class ExperimentsController < ApplicationController
	Mime::Type.register "text/plain", :chart_data
  before_filter :require_user, :except => [:run, :get_opinion, :show]
  before_filter(:only => :show) do |controller|
   controller.send(:require_user) unless controller.request.format.xml?
 end
 include SmartServiceWorkflowEngine
  
	def index
    @page_id = "experiments" 
		@experiments = Experiment.all(:conditions => {:user_id => current_user.id })
	end

	def show
    @page_id = "selected_experiment"
		@experiment = Experiment.first(:conditions => { :id => params[:id] })#, :user_id => current_user.id })
    session[:experiment] = { :id => @experiment.id, :name => @experiment.name, :type => 'show'}
		respond_to do |format|
			#format.html
			format.xml do
        @experiment_xml = @experiment.content
      end
			format.chart_data do 
				out = []
				@y_values = []
				JSON.parse(@experiment.result).select{ |k,v| k=='csv_data' }.each do |k,v|
					sv = v.split(', ')
					@y_values << sv[1].to_f
					out << "{ \"x\": #{sv[0]}, \"y\": #{sv[1]} }"
				end
				@csv = out.join(",\n")
				render "show.chart_data"
			end
		end
	end
  
	def new
    @page_id = "experiments"  
    @experiment = Experiment.new
    @experiment.sla = Sla.new
	end

	def create
    sla = Sla.new(:name => params[:experiment][:name])
    @experiment = Experiment.new
    @experiment.sla = sla
    @experiment.user_id=current_user.id
    @experiment.attributes = params[:experiment]
		if @experiment.save && @experiment.sla_id=sla.id
			redirect_to experiments_path
		else
			render :action => 'new'
		end
	end

  def edit
    @page_id = "experiments"
    @experiment = Experiment.first(:conditions => { :id => params[:id], :user_id => current_user.id })
  end

  def update
    @experiment = Experiment.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    @experiment.result = nil
    @experiment.ocena_bezpieczenstwa = nil
    @experiment.done = false
    @experiment.user_id=current_user.id
    if @experiment.update_attributes(params[:experiment]) #&& @experiment.update_attributes(:algorytm_doboru_uslug => Settings.first.algorytm_doboru_uslug)
     redirect_to experiments_path
    else
      render :action => 'edit'
    end
  end
  
	def destroy
    @experiment = Experiment.first(:conditions => { :id => params[:id], :user_id => current_user.id })
		@experiment.destroy
		redirect_to experiments_url
  end

  def show_result
    @page_id = 'experiments'
    @experiment = Experiment.find(params[:id])
    @result = @experiment.result
    @id = params[:id]
    respond_to do |format|
      format.xml
      format.html { render :layout => false }
    end
  end
  
  def save_result
    @experiment = Experiment.find(params[:id])
    result = @experiment.result
    @experiment.content = result;
    @experiment.ocena_bezpieczenstwa = nil
    @experiment.done = false
    @experiment.result = ""
    @experiment.save
    render :nothing => true
  end

def get_opinion
  @experiment = Experiment.find(params[:id])
  selected_services = Array.new

  experiment_data = Hash.from_xml(@experiment.result)["request"]["functionalities"]["functionality"]
  experiment_data = experiment_data.sort{ |a,b| a["id"] <=> b["id"] } 
  experiment_data.each do |w|
    temp_service_array = Array.new
    temp_service_array <<= w["services"]["service"]
    temp_service_array = temp_service_array.flatten
    temp_service_array.each do |s|
    if s["chosen"]=="true"
      selected_services << {"id" => s["id"], "functionalityID" => w["id"], "functionalityChild" => w["child"]}
    end
   end
  end
 
  data = selected_services.to_xml :root => "services"
  require 'soap/wsdlDriver'
  wsdl = "http://#{APP_CONFIG['opinions_url']}/wsdl"
  opinion = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
  result = ""
  begin
    #result = opinion.GetOpinion(data)
    request_result = opinion.XsdTest(data)
    xml_build = Builder::XmlMarkup.new(:target => result, :ident => 2 )
    xml_build.instruct! 
    xml_build.opinion {
      xml_build.belief(request_result.belief)
      xml_build.disbelief(request_result.disbelief)
      xml_build.uncertainty(request_result.uncertainty)
    }
  rescue
    result = ""
  end
  @experiment.ocena_bezpieczenstwa = result
  @experiment.save
  #redirect_to @experiment
  render :layout => 'empty'
 end

def compare_selected
  #TODO:
end

def run_form
  start_node = EngineUtils.xml_to_ssdl_struct(Experiment.find(params[:id]).content).nodes.select {|v| v.nodetype == 'Control' && v.controltype='Start'}
  @variables = start_node.first.inputs
  @id = params[:id]
  render :layout => false
end

def compose_form
  render :layout => false
end

def deploy
  @id = params[:id]
  ssdl = EngineUtils.xml_to_ssdl_struct(Experiment.find(params[:id]).content)
  ssdl.nodes = nil
  ssdl.parameters = nil
  ssdl.engine_config = nil
  ssdl.mediators = nil
  ssdl.qos = nil
  @inputdata = EngineUtils.ssdl_struct_to_xml(ssdl)
  render :layout => false
end

## TODO: Organize This Start

def deploy_run
  input_data = EngineUtils.xml_to_ssdl_struct(params[:xml]).inputdata
  @experiment = Experiment.find(params[:id])
    @experiment.execution_number = @experiment.execution_number + 1
    @experiment.last_used = DateTime.now
    @experiment.save
    ssdl = EngineUtils.xml_to_ssdl_struct(@experiment.content)
    
    ssdl.inputdata = input_data    
    ssdl.engine_config.processing = true;
    @result = run_extended(ssdl)
    
    render :layout => false
end

def view_stats
    smart_services_array = Experiment.find_all_by_user_id(current_user.id)
    @services = Array.new
    smart_services_array.each do | s |
      @services << { :name => s.name, :executions => s.execution_number }
    end
    render :layout => false
  end

def compose
  @experiment = Experiment.find(params[:id])
  ssdl = EngineUtils.xml_to_ssdl_struct(@experiment.content)
  ssdl.engine_config.composition = true
  ssdl.engine_config.processing = false
  
  begin
    result = run_extended(ssdl)
    @experiment.result = EngineUtils.ssdl_struct_to_xml(result)
    @experiment.ocena_bezpieczenstwa = nil
    @experiment.done = true
    @experiment.save
    @is_successfull = true
    status = 200
  rescue
    @is_successfull = false
    status = 503
  end

  render :layout => false, :status => status
end

def run
    @experiment = Experiment.find(params[:id])
    begin 
    @experiment.execution_number = @experiment.execution_number + 1
    @experiment.last_used = DateTime.now
    @experiment.save
    ssdl = EngineUtils.xml_to_ssdl_struct(@experiment.content)
   
    ssdl.inputdata.each do |var|
      puts var.inspect
      var.value = params[params.keys.find {|k| k.downcase == var.name.downcase}]
      puts var.inspect
    end
    
    ssdl.engine_config.processing = true;
    @result = run_extended(ssdl)
    status = 200
    rescue
    @result = Hash.new
    status = 503
    end
    render :layout => false, :status => status
end

def run_extended(smartservicegraph)
    engine_settings = current_user.engine_settings
    if(smartservicegraph.engine_config.composition)
      puts "COMPOSITION STARTED"
      smartservicegraph = engine_init(smartservicegraph, engine_settings)
    end
    if(smartservicegraph.engine_config.processing)
      puts "PROCESSING STARTED"
      result = engine_process(smartservicegraph)
      return result    
    end
    return smartservicegraph
end

def engine_init(smartservicegraph, engine_settings)
  if(has_functionalities(smartservicegraph) )
    @input_data = smartservicegraph.inputdata
    smartservicegraph.inputdata = nil
    
    @composition_service_name = Hash.from_xml(engine_settings)['config']['init']['compose']
    
    variable = SmartServiceInputVariable.new
    variable.name = 'ssdl'
    variable.type = 'SmartServiceGraph'
    variable.value = smartservicegraph
    
    @enginessdl = EngineUtils.xml_to_ssdl_struct(SmartEngineService.first(:conditions => { :name => @composition_service_name}).content)
    @enginessdl.inputdata = Array.new
    @enginessdl.inputdata << variable
    
    composition_result = EngineUtils.execute_smart_service(@enginessdl)
    smartservicegraph = composition_result.values.first    
    smartservicegraph.inputdata = @input_data    
  end
  return smartservicegraph
end

def engine_process(smartservicegraph)
  return EngineUtils.execute_smart_service(smartservicegraph)
end

def has_functionalities(smartservicegraph)
  has_fun = false
    smartservicegraph.nodes.each do |node|
      if(node.nodetype == "Functionality")
        has_fun = true
      end
  end
  return has_fun
end
## TODO: Organize This end
 def smart_service_info
   @experiments = Experiment.all(:conditions => {:user_id => current_user.id })
   render :layout => false
 end
 
 def atomic_services_info
   render :layout => false
 end
 
 def smart_service_control
   render :layout => false
 end
 
 def general_log
   render :file => "#{RAILS_ROOT}/log/general.log"
 end
  
 def detailed_log
   render :file => "#{RAILS_ROOT}/log/detailed.log"
 end
  

 
private
#def get_settings_visibility(parameters)
#  settings_hidden = []
#  settings_visible = []
#  parameters.each do |p|
#    p.visible ? settings_visible << p.name : settings_hidden << p.name unless p.name == "algorytm_doboru_uslug"
#  end
#  {'visible' => settings_visible, 'hidden' => settings_hidden}
#end
end