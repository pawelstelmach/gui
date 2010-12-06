class Experiment < ActiveRecord::Base
  has_one :sla_experiment
  has_one :sla, :through => :sla_experiment
	def self.human_name
		"kompozycja"
	end

	def something_changes?
		reg = /^max_kandydatow|iteracji_alg_h|iteracji_planow_sasiednich|waga_|ograniczenie_/
		self.attributes.detect { |k,v| k =~ reg and v!=nil and v.include?('..') }
  end
  
  #Setter do sla
  def sla_id=( sla_id )
    self.sla = Sla.find(sla_id)
  end
  
  def sla_id
    sla.nil? ? "" : sla.id
  end
end