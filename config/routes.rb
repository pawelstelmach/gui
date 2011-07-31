ActionController::Routing::Routes.draw do |map|
  #map.applet 'experiments/sla', :controller => 'experiments', :action => 'sla_applet'
  #map.applet 'experiments/:id/sla', :controller => 'experiments', :action => 'sla_applet'
  #map.applet 'experiments/sla/upload', :controller => 'experiments', :action => 'xml_upload'
  
  map.resources :experiments, :member => { :run => :get }, :collection => { :remote_Compose => :get, :get_opinion => :get, :show_result => :get, :general_log => :get, :detailed_log => :get, :uruchom_kompozycje => :get, :last => :get, :smart_service_control => :get, :smart_service_info => :get, :atomic_services_info => :get, :compose => :get, :run_form => :get, :view_stats => :get }#, :has_one => :sla
  map.resources :slas, :collection => { :get_slas => :get, :parse_xml => :post, :check_edges => :get }
  map.resources :parameters
  map.resources :users
  map.resources :user_sessions
  map.resources :repositories, :collection => { :repositories_info => :get, :ontologies_info => :get }
  map.resources :ontologies, :collection => { :information => :get, :concepts_info => :get }
  map.resources :mediators, :collection => { :view_stats => :get }
  map.resources :engines, :collection => { :update_config => :get }
  map.resources :smart_engine_services, :member => { :editor_update => :get }, :collection => { :editor_create => :get }
  map.resources :atomic_engine_services
  #map.resources :sla,  :has_many => :experiments
  
  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  map.workflow_engine_settings 'workflow_engine_settings', :controller => 'engines', :action => 'edit'
  map.settings 'settings', :controller => 'settings', :action => 'edit'
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.account "account", :controller => "users", :action => "edit"
  map.register "register", :controller => "users", :action => "new"
  map.resources :settings
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'experiments', :action => 'index'
  map.connect "/pages/get_photo/:id/:site", :controller => 'pages', :action => 'get_photo'
  # See how all your routes lay out with "rake routes"
	# Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  

end
