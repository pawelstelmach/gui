class SmartServiceNode < ActionWebService::Struct
  member :name, :string
  member :description, :string
  member :nodeclass, :string
  member :nodetype, :string
  member :inputs, [SmartServiceInput]
  member :outputs, [SmartServiceOutput]
  member :preconditions, [SmartServicePrecondition]
  member :effects, [SmartServiceEffect]
  member :address, :string     #adres usługi
  member :method, :string      #nazwa metody usługi
  member :controltype, :string #typ  dla typu control
  member :condition, :string
  member :alternatives, [SmartServiceNode]
  member :cost, :integer 
  member :response_time, :integer
  member :availability, :double
  member :succesful, :double
  member :reputation, :double
  member :frequency, :double
  member :nonfunctionalities, [SmartServiceQosParameter]
end