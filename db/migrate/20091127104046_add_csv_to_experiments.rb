class AddCsvToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :csv, :text
  end

  def self.down
    remove_column :experiments, :csv
  end
end
