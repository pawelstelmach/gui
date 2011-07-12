class Graph
  attr_accessor :nodes, :matrix, :start_nodes, :end_nodes
  def initialize string=nil
    @nodes = {}
    @start_nodes = [] # nodes with no incoming edges
    @end_nodes = [] # nodes with no outgoing edges
    @matrix = [] #adjacency matrix
    return unless string
    string =~ /digraph.*?\{(.*)\}/m
    return nil unless $1
    $1.strip.split("\n").each do |line|
      line =~ /([^\[]*\s*(?:->[^\[]*)*)(?:\[(.*)\])?/
      next unless $1.strip.length > 0
      attributes = $2
      n = $1.strip.split(/\s*->\s*/)
      attributes =~ /label\s*=\s*([0-9.]*)?/
      value = $1.to_f
      
      prevNode = n.shift
      unless @nodes[prevNode]
        @nodes[prevNode] = Node.new self, (n.empty? ? value : prevNode)
        @end_nodes << @nodes[prevNode]
        @start_nodes << @nodes[prevNode]
      end
      while node = n.shift #?!
        unless @nodes[node]
          @nodes[node] = Node.new self, node
          @end_nodes << @nodes[node]
        end
        @nodes[prevNode].edge nodes[node], value
        @end_nodes.delete @nodes[prevNode]
        @start_nodes.delete @nodes[node]
        prevNode = node
      end
    end
  end
  
  def self.load_adjacency_matrix names, matrix
    graph = Graph.new
    names.each { |name| graph.nodes[name] = Node.new(graph, name) }
    nodes = graph.nodes.values
    graph.start_nodes = nodes.clone
    matrix.each_with_index do |row, i|
      graph.end_nodes << nodes[i] if row == 0
      row.to_s(2).reverse.split('').each_with_index do |field, j|
        if field == '1'
          nodes[i].edge nodes[j], field 
          graph.start_nodes.delete nodes[j]
        end
      end
    end
    return graph
  end
  
  def self.sort *end_nodes
    sorted_list = []
    visited = Set.new
    visit = lambda do |*args|
      raise ArgumentError if args.empty? or args.size > 2
      node, chain = args
      if chain.nil?
        chain = Set.new
      end
      
      raise "The graph contains cycles!" if chain.include? node
      return if visited.include? node
      visited << node
      chain = chain.clone << node
      node.in_each { |e| visit[e.from, chain] }
      sorted_list << node
    end
    
    end_nodes.each &visit
    return sorted_list
  end
  
  def sort
    Graph.sort *@end_nodes
  end
  
  def partition
    levels = Hash.new 0
    visit = lambda do | node | #how does it work?
      levels[node] = (node.in_edges.map {|e| levels[e.from] } + [0]).max + 1
      node.each { |e| visit[e.to] }
    end
    
    start_nodes.each &visit
    result = []
    levels.each do |k,v|
      result[v-1] ||= []
      result[v-1] << k
    end
    return result
  end
  
  def eval mul, add
    partition.map { |nodes| mul.call nodes.map { |n| n.value  } }.inject &add
  end
  
  def eval2 mul, add
    closure = closure_matrix
    visit = lambda do |from, to_indices| #how does it work?
      if 2**from.index & to_indices > 0
        return [nil, from]
      end
      if from.out_edges.length == 0
        return [from.value, nil]
      elsif from.out_edges.length == 1
        val, to = visit[from.out_edges[0].to, to_indices]
        return [add.call(from.value, val), to]
      else
        # common to maska bitowa określająca wierzchołki do których jest droga
        # od wszystkich wyhchodzących krawędzi.
        # Zawsze zachodzi: common | to_indices == common
        common = from.out_edges.map { |e| closure[e.to.index] }.inject { |sum, elem| sum & elem }
        to = nil
        value = mul.call(from.out_edges.map do |e|
          val, to = visit[e.to, common]
          val
        end)
        if to
          return [add.call(from.value, value, visit[to, to_indices & ~2**to.index][0]), nil]
        else
          return [add.call(from.value, value), nil]
        end
      end
    end
    
    mul.call @start_nodes.map { |node| visit[node, 0][0]} 
  end
  
  def has_cycles?
    visited = Set.new
    visit = lambda do |*args|
      raise ArgumentError if args.empty? or args.size > 2
      node, chain = args
      if chain.nil?
        chain = Set.new
      end
      
      throw :done, true if chain.include? node
      return if visited.include? node
      visited << node
      chain = chain.clone
      chain << node
      node.in_each { |e| visit[e.from, chain] }
    end
    
    return catch(:done) { @end_nodes.each &visit; false }
  end
  
  def closure_matrix
    nodes = @end_nodes.clone
    matrix = @matrix.clone
    while node = nodes.shift
      node.in_each do |edge|
        matrix[edge.from.index] |= matrix[edge.to.index]
        nodes << edge.from
      end
    end
    matrix
  end
  
  def transitive_reduction
    closure = closure_matrix
    @nodes.values.each do |node|
      node.each do |edge|
        edge.remove if edge.to.in_edges.inject(false) { |r, e| r || closure[edge.from.index] & 2 ** e.from.index > 0 } #czy na pewno binarny and?
      end
    end
    self
  end
  
  def << node
    @nodes[node.value] = node
    node.graph = self
    node.index = matrix.length
    matrix << 0
  end
  
  def to_dot
    str = "digraph dg {\n"
    @nodes.values.each do |node|
      node.each { |edge| str << edge.from.value + " -> " + edge.to.value + "\n" }
    end
    str << '}'
    str
  end
end
