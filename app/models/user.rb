class User < ActiveRecord::Base
    acts_as_authentic do |c|
      c.validates_length_of_login_field_options :within => 3..20, :message => "Username must be between 3 and 2 characters"
      c.merge_validates_uniqueness_of_login_field_options :message => "Username already exists"
      c.merge_validates_format_of_email_field_options :message => "Invalid e-mail format"
      c.merge_validates_length_of_email_field_options :within => 1..50, :message => "E-mail address cannnot be blank" 
      c.merge_validates_length_of_password_field_options :message => "Password must contain at least 4 characters"
      c.merge_validates_confirmation_of_password_field_options :message => "Password does not match password confirmation"
      c.merge_validates_length_of_password_confirmation_field_options :message => "DoNotValidateField" #obejscie walidacji wbudowanej w authlogic, wspolpracujace z errors_helper  
    end 
    has_many :parameters
    has_many :experiments
    has_many :slas
    has_many :mediators
    has_one :engine


    
  def create_default_settings
    self.parameters.delete_all
    self.parameters.create(:name => 'max_kandydatow', :value => '5', :visible => true)
    self.parameters.create(:name => 'iteracji_planow_sasiednich', :value => '3', :visible => true)
    self.parameters.create(:name => 'iteracji_alg_h', :value => '5', :visible => true)
    self.parameters.create(:name => 'podobienstwo', :value => '0.7', :visible => true)
    self.parameters.create(:name => 'algorytm_doboru_uslug', :value => 'exact_match', :visible => true)
  end
    
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
