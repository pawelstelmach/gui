class AddFieldToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :algorytm_doboru_uslug, :string
  end

  def self.down
    remove_column :experiments, :algorytm_doboru_uslug
  end
end
