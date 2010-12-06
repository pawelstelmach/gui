# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  
  def experiment_link(experiment)
    if experiment[:type]=="show"
      Experiment.find(experiment[:id])
    else
      if experiment[:type]=="edit"
        edit_experiment_path(Experiment.find(experiment[:id]))
      else
        new_experiment_path 
      end
    end
  end
  
  def experiment_result_path(experiment)
    url_for(:controller => 'Experiments', :action => 'show_result', :id => experiment.id, :only_path => false)
  end
  
  def services_path(experiment)
    "http://#{APP_CONFIG['services_url']}/services"+ (experiment ? "/experiment/#{experiment[:id]}/#{experiment[:name]}/#{experiment[:type]}" : "")
  end
  
  def concepts_path(experiment)
    "http://#{APP_CONFIG['services_url']}/concepts"+ (experiment ? "/experiment/#{experiment[:id]}/#{experiment[:name]}/#{experiment[:type]}" : "")
  end

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
