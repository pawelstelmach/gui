module AtomicEngineServicesHelper
  
  include JqgridsHelper

    def services_jqgrid
      options = {:on_document_ready => true, :html_tags => false}
      grid = [{
        :url => '/atomic_engine_services',
        :datatype => 'json',
        :mtype => 'GET',
        :colNames => ['ID', 'Name', 'Address', 'Method', 'Description', 'Inputs', 'Outputs'],
        :colModel  => [
          { :name => 'id',   :index => 'id', :width => 30, :sortable => false },
          { :name => 'name',   :index => 'name', :width => 210, :sortable => false },
          { :name => 'address',   :index => 'address', :width => 210, :sortable => false },
          { :name => 'method', :index => 'method',  :width => 150, :sortable => false },
          { :name => 'description', :index => 'description',  :width => 150, :sortable => false },
          { :name => 'inputs', :index => 'inputs',  :width => 180, :sortable => false },
          { :name => 'outputs', :index => 'outputs',  :width => 180, :sortable => false },
        ],
        :sortname => 'id',
        :sortorder => 'desc',
        :viewrecords => true,
        :hiddengrid => false,
        #:height => 225,
        :pager => '#services_pager',
        :rowNum => 10,
        :rowList => [10, 25, 50],
        :caption => 'Composition Services'
        #:onSelectRow => "function() { alert('Row selected!');}".to_json_var
      }]

    pager = [:navGrid, "#services_pager", {:del => false , :add => false, :edit => false, :search => false}, {}, {}, {:closeOnEscape => true}]

    
    jqgrid_api 'services_list', grid, pager, options

    end
  
end
