class AtomicEngineServicesController < ApplicationController
  def index
    @page_id = "engine"
    @config_page_id = "repository"
    @columns = ['id', 'name', 'address', 'method', 'description', 'inputs', 'outputs']
    @services = AtomicEngineService.paginate(:page => params[:page], :per_page => params[:rows])

    if request.xhr?
      render :json => json_for_jqgrid(@services, @columns)
    else
      render
    end
  end
end
