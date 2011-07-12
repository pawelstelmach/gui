class AddLastUsedToExperiment < ActiveRecord::Migration
  def self.up
    add_column :experiments, :last_used, :datetime
    add_column :experiments, :execution_number, :integer
  end

  def self.down
    remove_column :experiments, :execution_number
    remove_column :experiments, :last_used
  end
end
