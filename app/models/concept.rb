class Concept < ActionWebService::Struct
  
  attr_accessor   :id, :name, :parent_id, :meta_in, :meta_out, :created_at, :updated_at, :routing_table
  
  def initialize(id, name, parent_id, meta_in, meta_out, created_at, updated_at, routing_table)
    self.id = id
    self.name = name
    self.parent_id = parent_id
    self.meta_in = meta_in
    self.meta_out = meta_out
    self.created_at = created_at
    self.updated_at = updated_at
    self.routing_table = routing_table
  end
  
  def attribute_names
    return ["created_at",
            "id",
            "name",
            "meta_in",
            "meta_out",
            "parent_id",
            "routing_table",
            "updated_at",
            ]
  end
  
  def attributes
     return {
            "id" => self.id,
            "name" => self.name,
            "parent_id" => self.parent_id,
            "meta_in" => self.meta_in,
            "meta_out" => self.meta_out,
            "created_at" => self.created_at,
            "updated_at" => self.updated_at,
            "routing_table" => self.routing_table
          }
  end
  
end