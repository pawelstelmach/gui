class RepositoriesController < ApplicationController
  def index      
    @page_id = "repositories"
    @mediators_data = Array.new
    current_user.mediators.each do |m|
      @mediators_data << { :id => m.id.to_s, :name => m.name }
    end
    
    if request.xhr?
      m = Mediator.find(params[:grid_id])
      require 'soap/wsdlDriver'
      mediator = SOAP::WSDLDriverFactory.new(m.url).create_rpc_driver
      begin
        t_start = Time.now
        #data = eval "mediator.getAllServices()"
        data = mediator.getAllServices()
        
        services = Array.new
        data.each do |s|
          services << Service.new(s.id, s.name, s.description, s.input, s.output, s.created_at,
                                  s.updated_at, s.cost, s.response_time, s.availability, s.succesful, 
                                  s.reputation, s.frequency, s.service_class
                                 )
        end
        t_end = Time.now
        m.add_response_time(t_end-t_start)
        @result = services.paginate(:page => params[:page], :per_page => params[:rows])
      rescue
        @result = [].paginate(:page => params[:page], :per_page => params[:rows])
      end    
      @columns = ['id', 'name', 'service_class', 'input', 'output']
      render :json => json_for_jqgrid(@result, @columns)
    end
  end
  
  def show
    render :layout => false
  end
  
  def ontologies_info
    render :layout => false
  end
  
  def repositories_info
    render :layout => false
  end
  
  def destroy
    @mediator = Mediator.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    @mediator.destroy
    redirect_to repositories_url
  end
  
  #for WE
  #address - string, method_name - string, args - arguments for wsdl method
  def execute_service(address, method_name, *args)
     result = false 
     arg_names = "";
     require 'soap/wsdlDriver'
     service = SOAP::WSDLDriverFactory.new(address).create_rpc_driver
     begin
       data = eval "service."+method_name+"(*args)"
       is_success = true
     rescue
       data = nil
       is_success = false
     end    
      
     return {:result => is_success, :data => data}
  end
    
end
