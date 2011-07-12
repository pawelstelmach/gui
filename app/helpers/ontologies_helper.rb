module OntologiesHelper
  include JqgridsHelper
  
  def ontologies_jqgrid(id, name)
    options = {:on_document_ready => true, :html_tags => false}

    grid = [{
      :url => '/ontologies?grid_id='+id,
      :datatype => 'json',
      :mtype => 'GET',
      :colNames => ['ID','Name', 'Parent ID', 'Meta in', 'Meta out'],
      :colModel  => [
          { :name => 'id',   :index => 'id',    :width => 30, :sortable => false },
          { :name => 'name', :index => 'name',  :width => 180, :sortable => false },
          { :name => 'parent_id', :index => 'parent_id',  :width => 180, :sortable => false },
          { :name => 'meta_in', :index => 'meta_in',  :width => 200, :sortable => false },
          { :name => 'meta_out', :index => 'meta_out',  :width => 200, :sortable => false }
        ],
      :pager => '#ontologies_pager_'+id,
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

    pager = [:navGrid, "#ontologies_pager_"+id, {:del => false , :add => false, :edit => false, :search => false}, {}, {}, {:closeOnEscape => true}]

    
    jqgrid_api 'ontologies_list_'+id, grid, pager, options
  end
end
