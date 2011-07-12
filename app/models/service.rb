class Service
  attr_accessor :id, :name, :description, :input, 
  :output, :created_at, :updated_at, :cost, 
  :response_time, :availability, :succesful, 
  :reputation, :frequency, :service_class
  
  def initialize(id, name, description, input, output, created_at, updated_at, cost, 
    response_time, availability, succesful, reputation, frequency, service_class)
    self.id = id
    self.name = name
    self.description = description
    self.input = input
    self.output = output
    self.created_at = created_at
    self.updated_at = updated_at
    self.cost = cost
    self.response_time = response_time
    self.availability = availability
    self.succesful = succesful
    self.reputation = reputation
    self.frequency = frequency
    self.service_class = service_class
  end
  
  def attribute_names
    return ["availability",
            "cost",
            "created_at",
            "description",
            "frequency",
            "id", 
            "input", 
            "name",
            "output",
            "reputation",
            "response_time",
            "service_class",
            "succesful",
            "updated_at"
            ]
  end
  
  def attributes
     return {
                  "id" => self.id, 
                  "name" => self.name, 
                  "description" => self.description, 
                  "input" => self.input, 
                  "output" => self.output, 
                  "created_at" => self.created_at, 
                  "updated_at" => self.updated_at, 
                  "cost" => self.cost, 
                  "response_time" => self.response_time, 
                  "availability" => self.availability, 
                  "succesful" => self.succesful, 
                  "reputation" => self.reputation, 
                  "frequency" => self.frequency, 
                  "service_class" => self.service_class
          }
  end
  
end