class AddFiledsToExperiment < ActiveRecord::Migration
  def self.up
    add_column :experiments, :waga_time, :string
    add_column :experiments, :ograniczenie_time, :string
  end

  def self.down
    remove_column :experiments, :ograniczenie_time
    remove_column :experiments, :waga_time
  end
end
