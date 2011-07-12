class Edge
  attr_accessor :value
  attr_reader :from, :to
  def initialize from, to, value=nil
    @from, @to = from, to
    @value = value
    from.instance_variable_get(:@out) << self
    to.instance_variable_get(:@in) << self
    @from.graph.matrix[@from.index] |= 2**@to.index
  end
  
  def remove
    @from.instance_variable_get(:@out).delete self
    @to.instance_variable_get(:@in).delete self
  end
end
