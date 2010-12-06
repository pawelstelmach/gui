class Settings < ActiveRecord::Base
   has_many :parameters
   
  def max_kandydatow=( val )
    self.parameters.first.update_attributes(:value => val)
  end
  
  def max_kandydatow
    self.parameters.first.value
  end
  
  def max_kandydatow_vis=( val )
    self.parameters.first.update_attributes(:visible => val)
  end
  
  def max_kandydatow_vis
    self.parameters.first.visible
  end
  
  def iteracji_planow_sasiednich=( val )
    self.parameters.second.update_attributes(:value => val)
  end
  
  def iteracji_planow_sasiednich
    self.parameters.second.value
  end
  
  def iteracji_planow_sasiednich_vis=( val )
    self.parameters.second.update_attributes(:visible => val)
  end
  
  def iteracji_planow_sasiednich_vis
    self.parameters.second.visible
  end
  
    def iteracji_alg_h=( val )
    self.parameters.third.update_attributes(:value => val)
  end
 
  def iteracji_alg_h
    self.parameters.third.value
  end
    def iteracji_alg_h_vis=( val )
    self.parameters.third.update_attributes(:visible => val)
  end
  
  def iteracji_alg_h_vis
    self.parameters.third.visible
  end
  
  def podobienstwo=( val )
    self.parameters.fourth.update_attributes(:value => val)
  end
   
  def podobienstwo
    self.parameters.fourth.value
  end
    def podobienstwo_vis=( val )
    self.parameters.fourth.update_attributes(:visible => val)
  end
  
  def podobienstwo_vis
    self.parameters.fourth.visible
  end
  
    def algorytm_doboru_uslug=( val )
    self.parameters.fifth.update_attributes(:value => val)
  end
  
  def algorytm_doboru_uslug
    self.parameters.fifth.value
  end 
  
  def settings_hash
    keys = []
    values = []
    self.parameters.each do |p|
      keys << p.name
      values << p.value
    end
    Hash[*keys.zip(values).flatten]   
  end
  
  def settings_visible
    settings_array = []
    self.parameters.each do |p|
      if p.visible
        setting_array << p
      end
    end
    settings_array
  end
  
  def settings_hidden
    settings_array = []
    self.parameters.each do |p|
      if !p.visible
        setting_array << p
      end
    end
    settings_array
  end
  
end
