class SlasController < ApplicationController
protect_from_forgery :except => [:create, :update]

  def index
    @page_id = "slas"
    @slas = Sla.all
  end
  
   def get_slas
     @slas = Sla.all
     render :layout => 'empty'
  end
  
  def show   
    @page_id = "slas"
    @sla = Sla.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end
  def new
    @page_id = "slas"
    @sla_url = url_for(:action => 'create', :controller => 'slas', :only_path => false)
    render :layout => 'simple'
  end
  
  def create
    sla_content = params[:file].read
    sla_name = params[:filename].read
    Sla.create(:name => sla_name, :content => sla_content)
    render :nothing => true, :status => 200
  end

  def parse_xml
    Sla.create(:name => params[:name], :content => params[:content])
    redirect_to slas_path
  end
  
  def edit 
    @page_id = "slas"
    @content = url_for(:action => 'show', :controller => 'slas', :id => "#{params[:id]}.xml", :only_path => false)
    @sla_url = "#{url_for(:controller => 'slas', :only_path => false)}/update/#{params[:id]}"
    @id = params[:id]
    @name = Sla.find(@id).name
    render :layout => 'simple'
  end
  
  def update
    sla_content = params[:file].read
    sla_name = params[:filename].read
    sla = Sla.find(params[:id])
    sla.update_attributes(:name => sla_name, :content => sla_content)
    render :nothing => true, :status => 200
  end
  
  def check_edges
    @sla = Sla.find(params[:id])
    data = {:sla => @sla.content}
    uri = URI.parse("http://#{APP_CONFIG['edges_url']}/run")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 1.hour
    http.read_timeout = 1.hour
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data( data )
    result = http.request(request)
    result = result.body.strip
    @sla.content = result
    @sla.save
    redirect_to edit_sla_path(@sla)
end
  
  def destroy
    @sla = Sla.find(params[:id])
    if(@sla.experiments.empty?)
      @sla.destroy
      flash[:notice] = "Usunięto wymagania funkcjonalne."
    else
      flash[:error] = "Nie można usunąć wymagań funkcjonalnych powiązanych z kompozycją"
    end
    redirect_to slas_url
  end
end
