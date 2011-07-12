class Mediator < ActiveRecord::Base
  validates_presence_of :name, :url
  validates_size_of :name, :within => 1..20
  validates_confirmation_of :password
  
  has_many :response_times
  belongs_to :user
  
  def add_response_time(respT)
    resp = response_times.build(:response_time => respT)   
    response_times.length > 5 ? response_times.delete(response_times.first) : true;
    self.save
  end
  
  def get_last_response_time
    
    response_times.length > 0 ? response_times.last.response_time : 0
  end
  
  def get_avrage_response_time
    sum = 0
    response_times.each do | t |
      sum += t.response_time;
    end
    return response_times.length > 0 ? sum/response_times.length : 0
  end
end
