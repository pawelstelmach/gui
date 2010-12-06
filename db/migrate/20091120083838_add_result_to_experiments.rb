class AddResultToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :result, :text
  end

  def self.down
    remove_column :experiments, :result
  end
end
