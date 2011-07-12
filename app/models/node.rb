class Node
  attr_accessor :value, :index, :graph
  include Enumerable
  def initialize graph=nil, value=nil
    @value = value
    @out = []
    @in = []
    if graph
      @graph = graph
      @index = @graph.matrix.length
      @graph.matrix << 0
    end
  end
  
  def edge to, value=nil
    Edge.new(self, to, value)
  end
  
  def each &block
    @out.each &block
  end
  
  def in_each &block
    @in.each &block
  end
  
  def in_edges
    @in
  end
  
  def out_edges
    @out
  end
  
  def path to
    closed = Set.new
    open = [self].to_set
    path = {}
    
    score = {self => 0}
    while node = open.min { |n| score[n] }
      if node == to
        return_path = []
        while from = path[node]
          return_path.unshift from
          node = from
        end
        return_path << to
        return return_path
      end
      
      open.delete node
      closed.add node
      node.each do |edge|
        next if closed.include? edge.to
        
        tmp_score = score[node] + edge.value
        
        is_better = false
        if !open.include?(edge.to)
          open << edge.to
          is_better = true
        elsif score < score[edge.to]
          is_better = true
        end
        
        if is_better
          path[edge.to] = node
          
          score[edge.to] = tmp_score
        end
      end
    end
    
    return nil
  end
  
  def longest_path to
    score = Hash.new 0
    max_edge = {}
    
    Graph.sort(to).each do |node|
      node.each do |edge|
        if score[node] + edge.value > score[edge.to]
          score[edge.to] = score[node] + edge.value
          max_edge[edge.to] = node
        end
      end
    end
    
    path = [to]
    while max_edge[path.last]
      path << max_edge[path.last]
    end
    path.reverse
  end
end
