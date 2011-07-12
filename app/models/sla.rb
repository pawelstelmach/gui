class Sla < ActiveRecord::Base
  has_many :sla_experiments
  has_many :experiments, :through => :sla_experiments
  belongs_to :user
end
