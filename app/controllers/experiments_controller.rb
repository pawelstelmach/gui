class ExperimentsController < ApplicationController
	Mime::Type.register "text/plain", :chart_data

	def uruchom_kompozycje
		render :text => `/usr/bin/python #{RAILS_ROOT}/public/service_execute \"#{params[:command]}\"`
	end

	def general_log
		render :file => "#{RAILS_ROOT}/log/general.log"
	end
	
	def detailed_log
		render :file => "#{RAILS_ROOT}/log/detailed.log"
	end
	
	def index
    @page_id = "experiments" 
		@experiments = Experiment.all
	end

	def show
    @page_id = "selected_experiment"
		@experiment = Experiment.find(params[:id])
    session[:experiment] = { :id => @experiment.id, :name => @experiment.name, :type => 'show'}
		respond_to do |format|
			format.html
			format.xml
			format.chart_data do 
				out = []
				@y_values = []
				JSON.parse(@experiment.result).select{ |k,v| k=='csv_data' }.each do |k,v|
					sv = v.split(', ')
					@y_values << sv[1].to_f
					out << "{ \"x\": #{sv[0]}, \"y\": #{sv[1]} }"
				end
				@csv = out.join(",\n")
				render "show.chart_data"
			end
		end
	end
  
	def new
    @page_id = "selected_experiment"  
		settings = Settings.first
    @experiment = Experiment.new(settings.settings_hash.merge({:waga_time => 1, :waga_cost => 1}))
    session[:experiment] = { :id => "new", :name => "Nowa kompozycja", :type => 'new'}
    visibility = get_settings_visibility(settings.parameters)
    @settings_visible = visibility['visible']
    @settings_hidden = visibility['hidden']
    @slas = Sla.all
	end

	def create
		@experiment = Experiment.new(params[:experiment])
		if @experiment.save
			flash[:notice] = "Utworzono nowa kompozycje."
			redirect_to @experiment
		else
			render :action => 'new'
		end
	end

	def edit
    @page_id = "selected_experiment"
		@experiment = Experiment.find(params[:id])
    session[:experiment] = { :id => @experiment.id, :name => @experiment.name, :type => 'edit'}    
    visibility = get_settings_visibility(Settings.first.parameters)
    @settings_visible = visibility['visible']
    @settings_hidden = visibility['hidden']
    @slas = Sla.all
	end

	def update
		@experiment = Experiment.find(params[:id])
		@experiment.result = nil
    @experiment.ocena_bezpieczenstwa = nil
		@experiment.done = false
		if @experiment.update_attributes(params[:experiment]) #&& @experiment.update_attributes(:algorytm_doboru_uslug => Settings.first.algorytm_doboru_uslug)
			flash[:notice] = "Zapisano zmiany w kompozycji."
			redirect_to @experiment
		else
			render :action => 'edit'
		end
	end

	def destroy
		@experiment = Experiment.find(params[:id])
    if session[:experiment][:id] == @experiment.id
      session[:experiment] = nil
    end
		@experiment.destroy
		flash[:notice] = "Usunięto kompozycje."
		redirect_to experiments_url
  end

  def show_result
    @result = Experiment.find(params[:id]).result
    respond_to do |format|
      format.xml
    end
  end

#Tymczasowa metoda
  def last
    redirect_to Experiment.find(:last)
  end

	def run
		@experiment = Experiment.find(params[:id])
		#stuff_to_log = "#{request.remote_ip}, #{@experiment.proces}, #{Time.now}\n"
    stuff_to_log = "#{request.remote_ip}, #{sla_url( @experiment.sla, :format => :xml )}, #{Time.now}\n"
		File.open("#{RAILS_ROOT}/log/general.log", 'a') { |f| f.write( stuff_to_log ) }
		data = { :url => experiment_url( @experiment, :format => :xml ) }
		uri = URI.parse("http://#{APP_CONFIG['runner_url']}/")
		http = Net::HTTP.new(uri.host, uri.port)
		http.open_timeout = 1.hour
		http.read_timeout = 1.hour
		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data( data )
		
		# begin
			result = http.request(request)
		# rescue Exception => e
		#	retry
		# end

		@experiment.result = result.body.strip
    @experiment.ocena_bezpieczenstwa = nil
    @experiment.done = true
		@experiment.save
end

def get_opinion
  @experiment = Experiment.find(params[:id])
  selected_services = Array.new

  experiment_data = Hash.from_xml(@experiment.result)["request"]["functionalities"]["functionality"]
  experiment_data = experiment_data.sort{ |a,b| a["id"] <=> b["id"] } 
  experiment_data.each do |w|
    temp_service_array = Array.new
    temp_service_array <<= w["services"]["service"]
    temp_service_array = temp_service_array.flatten
    temp_service_array.each do |s|
    if s["chosen"]
      selected_services << {"id" => s["id"]}
    end
   end
 end
 
 data = {:complex_service => (selected_services.to_xml :root => "services")}
 uri = URI.parse("http://#{APP_CONFIG['opinions_url']}/get_opinion")
 http = Net::HTTP.new(uri.host, uri.port)
 http.open_timeout = 1.hour
 http.read_timeout = 1.hour
 request = Net::HTTP::Post.new(uri.request_uri)
 request.set_form_data( data )
 result = http.request(request)
 result = result.body.strip
 @experiment.ocena_bezpieczenstwa = result
 @experiment.save
 #redirect_to @experiment
 render :layout => 'empty'
 end

private
  def get_settings_visibility(parameters)
    settings_hidden = []
    settings_visible = []
    parameters.each do |p|
      p.visible ? settings_visible << p.name : settings_hidden << p.name unless p.name == "algorytm_doboru_uslug"
    end
   {'visible' => settings_visible, 'hidden' => settings_hidden}
    end

end