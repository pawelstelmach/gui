module SmartServiceWorkflowEngine
  class Generic < Node
    attr_accessor :requires, :provides
    
    def initialize name
      super nil, name
      @requires = []
      @provides = []
    end
    
    def eval args
    puts "NodeEvalInvocation: "+self.index.to_s
      {}
  end
  end
  
  class Graph < Generic
    def initialize name, input='start', output='end', &block
      super name
      @graph = ::Graph.new
      if block
        instance_eval &block
      end
      @input = @graph.nodes[input]
      @output = @graph.nodes[output]
      @requires = @input.requires
      @provides = @output.provides
    end
    
    def eval args = []
      cache = {}
      args.length.times { |i| cache[@requires[i]] = args[i] }
      queue = [@input]    
      visited = Set.new queue
      while node = queue.shift
    unless node.requires.inject(true) { |s, r| r && cache[r] }
          queue << node
          next
        end
    #what happens from here?
        if node.is_a? Selector
          a = node.eval node.requires.map { |k| cache[k] }
          node.eval(node.requires.map { |k| cache[k] }).each do |e|
            p "p e.to.value: "+e.to.value
            queue << e.to
            visited << e.to
          end
        else
          cache.merge!(node.eval(node.requires.map { |k| {k => cache[k]} }))
          node.each do |e|
            unless visited.include? e.to
              queue << e.to
              visited << e.to
            end
          end
        end
    puts "cache: "+cache.to_s
      
      #TODO: check this
      #puts "queue: "+queue.to_s
      #puts "visited: "+visited.to_s
      end
      result = {}
      @provides.each { |k| result[k] = cache[k] }
      result
    end
    
    def proc *args, &block
      @graph << Proc.new(*args, &block)
    end
    
    def select *args, &block
    puts "goes into proc"
      @graph << Selector.new(*args, &block)
    end
  
  def serv *args
      @graph << Serv.new(*args)
    end
  
    
    def path *names
      prevNode = names.shift
      while node = names.shift
        @graph.nodes[prevNode].edge @graph.nodes[node]
        prevNode = node
      end
    end
  end
  
  class Proc < Generic
    def initialize name, requires=[], provides=nil, &block
      super name
    puts name+": "
    puts "  Requires: "+requires.inspect
    puts "  Provides: "+provides.inspect
      provides = [name] unless provides
      @proc = block
      @requires = requires
      @provides = provides
    end
    
    def eval args
  #TODO: Here should be the SOAP invocation inserted
      p "Evaluating #{@value}"
      instance_exec *args, &@proc
    end
  end
  
  class Selector < Proc
  end
  
  class Serv < Proc
  def initialize (name, service_address, method_name, requires=[], provides=nil)
    super name, requires, provides
    @address = service_address
    @method = method_name
  end
  
  def eval *args
    execute_service(@address, @method, requires, provides, args)
    end
  end
  
  def instance_exec(*args, &block)
    mname = "__instance_exec_#{Thread.current.object_id.abs}"
    metaclass.class_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      metaclass.class_eval{ undef_method(mname) } rescue nil
    end
  #puts "RET"+ret.to_s
    ret
  end
  
  def metaclass
    class << self 
      self 
    end
  end

  def execute_task(task, params)
    task.eval params
  end

  def execute_plan(plan)
    task = SmartServiceWorkflowEngine::Graph.new 'task' do
   # @graph << SmartServiceWorkflowEngine::Generic.new('start')
  #  @graph << SmartServiceWorkflowEngine::Generic.new('end')
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
          @graph << SmartServiceWorkflowEngine::Generic.new('start')
          inputnames = Array.new
          node.inputs.each do |input|
            inputnames << input.name
          end  
          @graph.nodes['start'].requires = inputnames
        end
      if node.controltype == "End"
          @graph << SmartServiceWorkflowEngine::Generic.new('end')
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

#      task = SmartServiceWorkflowEngine::Graph.new 'task' do
#    @graph << SmartServiceWorkflowEngine::Generic.new('start')
#    @graph << SmartServiceWorkflowEngine::Generic.new('end')
#    @graph.nodes['end'].provides = ['e']
#  @graph.nodes['start'].requires = ['a', 'b']
#    serv 's1', 'http://localhost:3000/math/wsdl', 'addNewServ', ['a', 'b'], 'c'
#    serv 's2', 'http://localhost:3001/math/wsdl', 'addServ', ['c', 'c'], 'd'
#    serv 's3', 'http://localhost:3001/math/wsdl', 'addServ', ['d', 'd'], 'e'
#    #select '?', ['b'] do |b|
    #  if b < 5
    #    [@out[0], @in[0]]
    #  else
    #    [@out[1]]
    #  end
    #end
#    path 'start', 's1', 's2', 's3'
#  end
  puts "zakończył tworzenie"
  p task.eval [1, 2]
  
  #http://localhost:3000/math/wsdl
  end

  
end

def execute_service(address, method_name, requires, data_variable, *args)
     result = false 
     arg_names = "";
     require 'soap/wsdlDriver'
     service = SOAP::WSDLDriverFactory.new(address).create_rpc_driver
   params = {}
   args.flatten.each do |v|
    params.merge!(v)
   end
   
   params_arr = Array.new
   requires.each do |k|
    params_arr << "params['"+k+"']"
   end
   params_string = params_arr.join(',')
   puts params_string
   
    if params['c']!=nil
     puts params['c']
    end
     begin
      data = Kernel::eval "service."+method_name+"("+params_string+")" 
      #data = eval "service."+method_name+"(*args)"
      is_success = true
     rescue => e
       puts e.message
       puts e.backtrace
       puts "ERROR!!"
       data = nil
       is_success = false
      end
      puts data.inspect      
      return {data_variable => data}
  end  
#added and important


  
  
#if __FILE__ == $0
#  task = SmartServiceWorkflowEngine::Graph.new 'task' do
#    @graph << SmartServiceWorkflowEngine::Generic.new('start')
#    @graph << SmartServiceWorkflowEngine::Generic.new('end')
#    @graph.nodes['end'].provides = ['a']
#    proc 'a', ['c'] do |c|; {'a' => c}; end
#    proc 'b', [], ['b','c'] do; {'b' => 3, 'c' => []}; end
#    proc 'c', ['b', 'c'], ['b', 'c'] do |b, c|; c << b; {'c' => c, 'b' => b + 1}; end
#    proc '+', ['a', 'b'] do |a, b| {'+' => a + b} end
#    select '?', ['b'] do |b|
#      if b < 5
#        [@out[0], @in[0]]
#      else
#        [@out[1]]
#      end
#    end
#    path 'start', 'b', '?'
#    path 'start', '?', 'c'
#    path 'start', '?', 'a'
#  end
#  p task.eval
#end
