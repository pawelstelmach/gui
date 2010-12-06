class SlaExperiment < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :sla
end
