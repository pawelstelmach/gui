class CreateSlaExperiments < ActiveRecord::Migration
  def self.up
    create_table :sla_experiments do |t|
      t.integer :experiment_id
      t.integer :sla_id

      t.timestamps
    end
    add_index :sla_experiments, :experiment_id
    add_index :sla_experiments, :sla_id
  end

  def self.down
    drop_table :sla_experiments
  end
end
