class OntologiesController < ApplicationController
  
  def index
    @page_id = "ontologies"
    @mediators_data = Array.new
    current_user.mediators.each do |m|
      @mediators_data << { :id => m.id.to_s, :name => m.name }
    end
    @mediator = Mediator.new
    
    if request.xhr?
      m = Mediator.find(params[:grid_id])
      require 'soap/wsdlDriver'
      mediator = SOAP::WSDLDriverFactory.new(m.url).create_rpc_driver
      begin
        data = mediator.getAllConcepts()
        concepts = Array.new
        data.each do |c|
          concepts << Concept.new(c.id, c.name, c.parent_id, c.meta_in, c.meta_out, c.created_at, c.updated_at, c.routing_table)
        end
        puts "gets services"
        @result = concepts.paginate(:page => params[:page], :per_page => params[:rows])
      rescue
        puts "throws exception"
        @result = [].paginate(:page => params[:page], :per_page => params[:rows])
      end    
      @columns = ['id', 'name', 'parent_id', 'meta_in', 'meta_out']
      render :json => json_for_jqgrid(@result, @columns)
    end
  end
  
  def information
    render :layout => false
  end
  
  def concepts_info
    render :layout => false
  end
  
  def destroy
    @mediator = Mediator.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    @mediator.destroy
    redirect_to ontologies_url
  end
end
