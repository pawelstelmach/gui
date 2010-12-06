class AddPodobienstwoToExperiment < ActiveRecord::Migration
  def self.up
    add_column :experiments, :podobienstwo, :float
  end

  def self.down
    remove_column :experiments, :podobienstwo
  end
end
