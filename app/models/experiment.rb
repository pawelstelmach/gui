class Experiment < ActiveRecord::Base
  has_one :sla_experiment
  has_one :sla, :through => :sla_experiment
  belongs_to :user
	def self.human_name
		"Smart service"
	end

  def initialize
    super
    self.execution_number = 0;
  end
  
	def something_changes?
		reg = /^max_kandydatow|iteracji_alg_h|iteracji_planow_sasiednich|waga_|ograniczenie_/
		self.attributes.detect { |k,v| k =~ reg and v!=nil and v.include?('..') }
  end
  
  #Setter do sla    
    
  def sla_id=( sla_id )
    begin
      self.sla = Sla.find(sla_id)
      return true
    rescue
      return false
    end
  end
  
  def sla_id
    sla.nil? ? "" : sla.id
  end
  
  def content
    sla.content
  end
  
    def content=( val )
    self.sla.update_attributes(:content => val)
  end
  
  def last_used= value
    self.class.record_timestamps = false
    self[:last_used] = value
    save!
    self.class.record_timestamps = true
  end
  
end