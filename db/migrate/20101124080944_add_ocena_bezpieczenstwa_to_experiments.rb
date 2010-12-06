class AddOcenaBezpieczenstwaToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :ocena_bezpieczenstwa, :text
  end

  def self.down
    remove_column :experiments, :ocena_bezpieczenstwa
  end
end
