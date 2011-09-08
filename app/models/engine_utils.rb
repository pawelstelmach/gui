class EngineUtils
  include SmartServiceWorkflowEngine


  def self.xml_to_ssdl_struct(xml)
  ssdl = SmartServiceGraph.new
  if(!xml.nil? || xml!="")
    graph = Hash.from_xml( xml )['graph'] 
    if(!graph['nodes'].nil?)
      ssdl.nodes = Array.new
      if(graph['nodes']['node'].is_a? Array)
        graph['nodes']['node'].each do |node_var|
          node = SmartServiceNode.new
          node.name = node_var['name']
          node.nodeclass = node_var['class']
          node.nodetype  = node_var['nodetype']
          node.inputs = Array.new
          if(!node_var['inputs'].nil?)
          if(node_var['inputs']['input'].is_a? Array)
            node_var['inputs']['input'].each do |input_var|
              variable = SmartServiceInput.new
              variable.metaname = input_var['metaname']
              variable.name = input_var['name']
              variable.type = input_var['type']
              variable.source = input_var['source']
              node.inputs << variable
            end
          else
            if(node_var['inputs']['input']!=nil)
            variable = SmartServiceInput.new
            variable.metaname = node_var['inputs']['input']['metaname']
            variable.name = node_var['inputs']['input']['name']
            variable.type = node_var['inputs']['input']['type']
            variable.source = node_var['inputs']['input']['source']
            node.inputs << variable
            end
          end
          end
          if(!node_var['outputs'].nil?)
          node.outputs = Array.new
          if(node_var['outputs']['output'].is_a? Array)
            node_var['outputs']['output'].each do |output_var|
              variable = SmartServiceOutput.new
              variable.metaname = output_var['metaname']
              variable.name = output_var['name']
              variable.type = output_var['type']
              node.outputs << variable
            end
          else
            if(node_var['outputs']['output']!=nil)
            variable = SmartServiceOutput.new
            variable.metaname = node_var['outputs']['output']['metaname']
            variable.name = node_var['outputs']['output']['name']
            variable.type = node_var['outputs']['output']['type']
            node.outputs << variable
            end
          end
          end
          if(!node_var['nonfunctionalities'].nil?)
            node.nonfunctionalities = Array.new
            if(node_var['nonfunctionalities']['nonfunctionality'].is_a? Array)
              node_var['nonfunctionalities']['nonfunctionality'].each do |qos_var|
                variable = SmartServiceQosParameter.new
                variable.name = qos_var['name']
                variable.unit = qos_var['unit']
                variable.value = qos_var['value']
                variable.weight = qos_var['weight']
                variable.relation = qos_var['relation']
                node.nonfunctionalities << variable
              end
            else
              if(node_var['nonfunctionalities']['nonfunctionality']!=nil)
              variable = SmartServiceQosParameter.new
                variable.name = node_var['nonfunctionalities']['nonfunctionality']['name']
                variable.unit = node_var['nonfunctionalities']['nonfunctionality']['unit']
                variable.value = node_var['nonfunctionalities']['nonfunctionality']['value']
                variable.weight = node_var['nonfunctionalities']['nonfunctionality']['weight']
                variable.relation = node_var['nonfunctionalities']['nonfunctionality']['relation']
                node.nonfunctionalities << variable
              end
            end
          end
          #node.preconditions  = graph['nodes']['node']['name']
          #node.effects  = graph['nodes']['node']['name']
          node.address  = node_var['address']
          node.method  = node_var['method']
          node.controltype  = node_var['controltype']
          node.condition  = node_var['condition']
          node.description = node_var['description']
          node_alternatives_xml_to_ssdl(node)
          ssdl.nodes << node
        end 
      else
        node = SmartServiceNode.new
        node.name = graph['nodes']['node']['name']
        node.class  = graph['nodes']['node']['class']
        node.nodetype  = graph['nodes']['node']['nodetype']
        node.inputs = Array.new
        if(graph['nodes']['node']['inputs']['input'].is_a? Array)
          graph['nodes']['node']['inputs']['input'].each do |input_var|
            variable = SmartServiceInput.new
            variable.metaname = input_var['metaname']
            variable.name = input_var['name']
            variable.type = input_var['type']
            variable.source = input_var['source']
            node.inputs << variable
          end
        else
          variable = SmartServiceInput.new
          variable.metaname = graph['nodes']['node']['inputs']['input']['metaname']
          variable.name = graph['nodes']['node']['inputs']['input']['name']
          variable.type = graph['nodes']['node']['inputs']['input']['type']
          variable.source = graph['nodes']['node']['inputs']['input']['source']
          node.inputs << variable
        end
        
        node.outputs = Array.new
        if(graph['nodes']['node']['outputs']['output'].is_a? Array)
          graph['nodes']['node']['outputs']['output'].each do |output_var|
            variable = SmartServiceOutput.new
            variable.metaname = output_var['metaname']
            variable.name = output_var['name']
            variable.type = output_var['type']
            node.outputs << variable
          end
        else
          variable = SmartServiceOutput.new
          variable.metaname = graph['nodes']['node']['outputs']['output']['metaname']
          variable.name = graph['nodes']['node']['outputs']['output']['name']
          variable.type = graph['nodes']['node']['outputs']['output']['type']
          node.outputs << variable
        end
        
        #node.preconditions  = graph['nodes']['node']['name']
        #node.effects  = graph['nodes']['node']['name']
        node.address  = graph['nodes']['node']['address']
        node.method  = graph['nodes']['node']['method']
        node.controltype  = graph['nodes']['node']['controltype']
        node.condition  = graph['nodes']['node']['condition']
        self.node_alternatives_xml_to_ssdl(node)
        ssdl.nodes << node
      end
      
    end
    
    if(!graph['inputdata'].nil?)
      ssdl.inputdata = Array.new
      if(graph['inputdata']['input_variable'].is_a? Array)
        graph['inputdata']['input_variable'].each do |input_var|
          variable = SmartServiceInputVariable.new
          variable.name = input_var['name']
          variable.value = input_var['value']
          variable.type = input_var['type']
          ssdl.inputdata << variable
        end
      else
        variable = SmartServiceInputVariable.new
        variable.name = graph['inputdata']['input_variable']['name']
        variable.value = graph['inputdata']['input_variable']['value']
        variable.type = graph['inputdata']['input_variable']['type']
        ssdl.inputdata << variable
      end
    end
    
    if(!graph['parameters'].nil?)
      ssdl.parameters = SmartServiceParameters.new
      ssdl.parameters.neighbour_plans = graph['parameters']['neighbour_plans']
      ssdl.parameters.max_candidates = graph['parameters']['max_candidates']
      ssdl.parameters.similarity = graph['parameters']['similarity']
      ssdl.parameters.selection = graph['parameters']['selection']
      ssdl.parameters.iterations = graph['parameters']['iterations']
    end
    
    if(!graph['engine_config'].nil?)
      ssdl.engine_config = SmartServiceEngineConfig.new
      ssdl.engine_config.composition = graph['engine_config']['composition'] == "true"
      ssdl.engine_config.processing = graph['engine_config']['processing'] == "true"
    end
    
    
    if(!graph['qos'].nil?)
      ssdl.qos = SmartServiceQos.new
      if(!graph['qos']['cost'].nil?)
        ssdl.qos.cost = SmartServiceQosParameter.new
        ssdl.qos.cost.weight = graph['qos']['cost']['weight']
        ssdl.qos.cost.unit = graph['qos']['cost']['unit']
        ssdl.qos.cost.value = graph['qos']['cost']['value']
        ssdl.qos.cost.relation = graph['qos']['cost']['relation']
      end
  
      if(!graph['qos']['time'].nil?)
        ssdl.qos.time = SmartServiceQosParameter.new
        ssdl.qos.time.weight = graph['qos']['time']['weight']
        ssdl.qos.time.unit = graph['qos']['time']['unit']
        ssdl.qos.time.value = graph['qos']['time']['value']
        ssdl.qos.time.relation = graph['qos']['time']['relation']
      end
    
      ssdl.qos.time = SmartServiceQosParameter.new
      if(!graph['qos']['dexterity'].nil?)
        ssdl.qos.time.weight = graph['qos']['dexterity']['weight']
        ssdl.qos.time.unit = graph['qos']['dexterity']['unit']
        ssdl.qos.time.value = graph['qos']['dexterity']['value']
        ssdl.qos.time.relation = graph['qos']['dexterity']['relation']
      end
    end
    
    if(!graph['mediators'].nil?)
      ssdl.mediators = Array.new
      if(graph['mediators']['mediator'].is_a? Array)
        graph['mediators']['mediator'].each do |mediator|
          variable = SmartServiceMediator.new
          variable.name = mediator['name']
          variable.address = mediator['address']
          variable.username = mediator['username']
          variable.password = mediator['password']
          ssdl.mediators << variable
        end
      else
        variable = SmartServiceMediator.new
        variable.name = graph['mediators']['mediator']['name']
        variable.address = graph['mediators']['mediator']['address']
        variable.username = graph['mediators']['mediator']['username']
        variable.password = graph['mediators']['mediator']['password']
        ssdl.mediators << variable
      end
    end
  end
  return ssdl
end

def self.ssdl_struct_to_xml(struct)
  result = ""
  xml_build = Builder::XmlMarkup.new(:target => result, :ident => 2 )
  xml_build.instruct! 
  if(!struct.nil?)
  xml_build.graph {
    if(!struct.nodes.nil?)
      xml_build.nodes{
        struct.nodes.each do |node|
          xml_build.node {
            xml_build.name(node.name)
            xml_build.class(node.nodeclass)
            xml_build.nodetype(node.nodetype)
            xml_build.inputs {
              unless node.inputs.nil?
              node.inputs.each do |input|
                xml_build.input {
                  xml_build.metaname(input.metaname)
                  xml_build.name(input.name)
                  xml_build.type(input.type)
                  xml_build.source(input.source)
                }
              end
              end
            }
            xml_build.outputs {
              unless node.outputs.nil?
              node.outputs.each do |output|
                xml_build.output {
                  xml_build.metaname(output.metaname)
                  xml_build.name(output.name)
                  xml_build.type(output.type)
                }
              end
              end
            }
            if(!node.nonfunctionalities.nil?)
              xml_build.nonfunctionalities {
                node.nonfunctionalities.each do |nonfun|
                  xml_build.nonfunctionality {
                    xml_build.name(nonfun.name)
                    xml_build.unit(nonfun.unit)
                    xml_build.value(nonfun.value)
                    xml_build.weight(nonfun.weight)
                    xml_build.relation(nonfun.relation)
                  }
              end
              }
            end
            
            xml_build.preconditions("")
            xml_build.effects("")
            xml_build.address(node.address)
            xml_build.method(node.method)
            xml_build.controltype(node.controltype)
            xml_build.condition(node.condition)
            node_alternatives_ssdl_to_xml(node, xml_build)
          }
        end
      }
    end
    if(!struct.inputdata.nil?)
      xml_build.inputdata {
        struct.inputdata.each do |inpdat|
          xml_build.input_variable {
            xml_build.name(inpdat.name)
            xml_build.value(inpdat.value)
            xml_build.type(inpdat.type)
          }
        end
      }
    end
    if(!struct.parameters.nil?)
      xml_build.parameters {
        xml_build.max_candidates(struct.parameters.max_candidates)
        xml_build.iterations(struct.parameters.iterations)
        xml_build.neighbour_plans(struct.parameters.neighbour_plans)
        xml_build.similarity(struct.parameters.similarity)
        xml_build.selection(struct.parameters.selection)
      }
    end
    if(!struct.engine_config.nil?)
      xml_build.engine_config {
        xml_build.composition(struct.engine_config.composition)
        xml_build.processing(struct.engine_config.processing)
       }
    end
    if(!struct.qos.nil?)
      xml_build.qos {
        if(!struct.qos.time.nil?)
        xml_build.time {
          xml_build.relation(struct.qos.time.relation)
          xml_build.value(struct.qos.time.value)
          xml_build.unit(struct.qos.time.unit)
          xml_build.weight(struct.qos.time.weight)
          }
        end
        if(!struct.qos.cost.nil?)
          xml_build.cost {
            xml_build.relation(struct.qos.cost.relation)
            xml_build.value(struct.qos.cost.value)
            xml_build.unit(struct.qos.cost.unit)
            xml_build.weight(struct.qos.cost.weight)
          }
        end
#        if(!struct.qos.dexterity.nil?)
#          xml_build.dexterity {
#            xml_build.relation(struct.qos.dexterity.relation)
#            xml_build.value(struct.qos.dexterity.value)
#            xml_build.unit(struct.qos.dexterity.unit)
#            xml_build.weight(struct.qos.dexterity.weight)
#          }
#        end
      }
    end
    if(!struct.mediators.nil?)
      xml_build.mediators {
        struct.mediators.each do |mediator|
          xml_build.mediator {
            xml_build.name(mediator.name)
            xml_build.address(mediator.address)
            xml_build.username(mediator.username)
            xml_build.password(mediator.password)
          }
        end
      }
    end
  }
  end
  return result
end

 def self.execute_smart_service(plan)
    task = SmartServiceWorkflowEngine::Graph.new 'task' do
      @graph << SmartServiceWorkflowEngine::Generic.new('start')
      @graph << SmartServiceWorkflowEngine::Generic.new('end')
      puts @graph.nodes['end']
      puts @graph.nodes['start']
      paths = Set.new
      plan.nodes.each do |node|
        puts plan.nodes.size
        if node.nodetype == "Service"          
          inputnames = Array.new
          outputname = ""
          node.inputs.each do |input|
            inputnames << input.name
            paths << [input.source, node.name]
          end  
          node.outputs.each do |output|
            outputname = output.name
          end
          serv(node.name, node.address, node.method, inputnames, outputname)
        end
        if node.nodetype == "Control"
          if node.controltype == "Start"
            inputnames = Array.new
            node.inputs.each do |input|
              inputnames << input.name
            end  
            @graph.nodes['start'].requires = inputnames
          end
          if node.controltype == "End"
            outputnames = Array.new
            node.outputs.each do |output|
              outputnames << output.name
            end
            @graph.nodes['end'].provides = outputnames
          end
        end
      end
      
      paths.each do |elem|
        path elem[0], elem[1]
      end
    end
    

    
    params = Array.new
    plan.inputdata.each do |var|
      params << var.value  
    end
     #TODO: 3P
    this = self.new
    return this.execute_task(task, params)
    
  end

  
  def self.node_alternatives_xml_to_ssdl(source_node)
    if(!source_node['alternatives'].nil?)
      source_node.alternatives = Array.new
      if(source_node['alternatives']['node'].is_a? Array)
        source_node['alternatives']['node'].each do |node_var|
          node = SmartServiceNode.new
          node.name = node_var['name']
          node.nodeclass = node_var['class']
          node.nodetype  = node_var['nodetype']
          node.inputs = Array.new
          if(node_var['inputs']['input'].is_a? Array)
            node_var['inputs']['input'].each do |input_var|
              variable = SmartServiceInput.new
              variable.metaname = input_var['metaname']
              variable.name = input_var['name']
              variable.type = input_var['type']
              variable.source = input_var['source']
              node.inputs << variable
            end
          else
            variable = SmartServiceInput.new
            variable.metaname = node_var['inputs']['input']['metaname']
            variable.name = node_var['inputs']['input']['name']
            variable.type = node_var['inputs']['input']['type']
            variable.source = node_var['inputs']['input']['source']
            node.inputs << variable
          end
          
          node.outputs = Array.new
          if(node_var['outputs']['output'].is_a? Array)
            node_var['outputs']['output'].each do |output_var|
              variable = SmartServiceOutput.new
              variable.metaname = output_var['metaname']
              variable.name = output_var['name']
              variable.type = output_var['type']
              node.outputs << variable
            end
          else
            variable = SmartServiceOutput.new
            variable.metaname = node_var['outputs']['output']['metaname']
            variable.name = node_var['outputs']['output']['name']
            variable.type = node_var['outputs']['output']['type']
            node.outputs << variable
          end
          #node.preconditions  = graph['nodes']['node']['name']
          #node.effects  = graph['nodes']['node']['name']
          node.address  = node_var['address']
          node.method  = node_var['method']
          node.controltype  = node_var['controltype']
          node.condition  = node_var['condition']
          source_node.alternatives << node
        end 
      else
        node = SmartServiceNode.new
        node.name = source_node['alternatives']['node']['name']
        node.class  = source_node['alternatives']['node']['class']
        node.nodetype  = source_node['alternatives']['node']['nodetype']
        node.inputs = Array.new
        if(source_node['alternatives']['node']['inputs']['input'].is_a? Array)
          source_node['alternatives']['node']['inputs']['input'].each do |input_var|
            variable = SmartServiceInput.new
            variable.metaname = input_var['metaname']
            variable.name = input_var['name']
            variable.type = input_var['type']
            variable.source = input_var['source']
            node.inputs << variable
          end
        else
          variable = SmartServiceInput.new
          variable.metaname = source_node['alternatives']['node']['inputs']['input']['metaname']
          variable.name = source_node['alternatives']['node']['inputs']['input']['name']
          variable.type = source_node['alternatives']['node']['inputs']['input']['type']
          variable.source = source_node['alternatives']['node']['inputs']['input']['source']
          node.inputs << variable
        end
        
        node.outputs = Array.new
        if(source_node['alternatives']['node']['outputs']['output'].is_a? Array)
          source_node['alternatives']['node']['outputs']['output'].each do |output_var|
            variable = SmartServiceOutput.new
            variable.metaname = output_var['metaname']
            variable.name = output_var['name']
            variable.type = output_var['type']
            node.outputs << variable
          end
        else
          variable = SmartServiceOutput.new
          variable.metaname = source_node['alternatives']['node']['outputs']['output']['metaname']
          variable.name = source_node['alternatives']['node']['outputs']['output']['name']
          variable.type = source_node['alternatives']['node']['outputs']['output']['type']
          node.outputs << variable
        end
        #node.preconditions  = graph['nodes']['node']['name']
        #node.effects  = graph['nodes']['node']['name']
        node.address  = source_node['alternatives']['node']['address']
        node.method  = source_node['alternatives']['node']['method']
        node.controltype  = source_node['alternatives']['node']['controltype']
        node.condition  = source_node['alternatives']['node']['condition']
        source_node.alternatives << node
      end
    end
  end
  
  def self.node_alternatives_ssdl_to_xml(node, xml_build)
    
    if(!node.alternatives.nil?)
      xml_build.alternatives{
        node.alternatives.each do |node|
          xml_build.node {
            xml_build.name(node.name)
            xml_build.class(node.nodeclass)
            xml_build.nodetype(node.nodetype)
            xml_build.inputs {
              node.inputs.each do |input|
                xml_build.input {
                  xml_build.metaname(input.metaname)
                  xml_build.name(input.name)
                  xml_build.type(input.type)
                  xml_build.source(input.source)
                }
              end
            }
            xml_build.outputs {
              node.outputs.each do |output|
                xml_build.output {
                  xml_build.metaname(output.metaname)
                  xml_build.name(output.name)
                  xml_build.type(output.type)
                }
              end
            }
            xml_build.preconditions("")
            xml_build.effects("")
            xml_build.address(node.address)
            xml_build.method(node.method)
            xml_build.controltype(node.controltype)
            xml_build.condition(node.condition)
          }
        end
      }
    end
  
  
  end
  
#  def self.get_input_variable_value(value, type)
#    case type
#      when "String"
#        return value
#      when "Integer"
#        return Integer(value)
#      when "Double"
#        return Double(value)
#      when "Float"
#        return Float(value)
#      else
#        return value
#      end
#  end
  end