class ComposerEngineServicesController < ApplicationController
  wsdl_service_name 'ComposerEngineServices'
  web_service_api ComposerEngineServicesApi
  web_service_scaffold :invocation if Rails.env == 'development'
  
  def compose(ssdl)
    engine_settings = User.find(10).engine_settings
    if(ssdl.engine_config.composition)
      puts "COMPOSITION STARTED"
      smartservicegraph = engine_init(ssdl, engine_settings)
    end
    
    return smartservicegraph
  end
  
  private
  def engine_init(smartservicegraph, engine_settings)
  if(has_functionalities(smartservicegraph) )
    @input_data = smartservicegraph.inputdata
    smartservicegraph.inputdata = nil
    
    @composition_service_name = Hash.from_xml(engine_settings)['config']['init']['compose']
    
    variable = SmartServiceInputVariable.new
    variable.name = 'ssdl0'
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

def has_functionalities(smartservicegraph)
  has_fun = false
    smartservicegraph.nodes.each do |node|
      if(node.nodetype == "Functionality")
        has_fun = true
      end
  end
  return has_fun
end
end
