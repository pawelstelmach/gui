module RepositoriesHelper
  include JqgridsHelper
  
  def repositories_jqgrid(id, name)
    options = {:on_document_ready => true, :html_tags => false}

    grid = [{
      :url => '/repositories?grid_id='+id,
      :datatype => 'json',
      :mtype => 'GET',
      :colNames => ['ID','Name', 'Class', 'Input', 'Output'],
      :colModel  => [
          { :name => 'id',   :index => 'id',    :width => 30, :sortable => false },
          { :name => 'name', :index => 'name',  :width => 180, :sortable => false },
          { :name => 'service_class', :index => 'service_class',  :width => 180, :sortable => false },
          { :name => 'input', :index => 'input',  :width => 200, :sortable => false },
          { :name => 'output', :index => 'output',  :width => 200, :sortable => false },
        ],
      :pager => '#repositories_pager_'+id,
      :rowNum => 10,
      :rowList => [10, 25, 50, 100],
      :sortname => 'id',
      :sortorder => 'desc',
      :viewrecords => true,
      :hiddengrid => true,
      #:altRows => true,
      :caption => name,
      :height => 225,
      #:onSelectRow => "function() { alert('Row selected!');}".to_json_var
    }]

    pager = [:navGrid, "#repositories_pager_"+id, {:del => false , :add => false, :edit => false, :search => false}, {}, {}, {:closeOnEscape => true}]

    
    jqgrid_api 'repositories_list_'+id, grid, pager, options
  end
end
