class CreateAtomicEngineServices < ActiveRecord::Migration
  def self.up
    create_table :atomic_engine_services do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :method
      t.string :service_class
      t.string :inputs
      t.string :outputs

      t.timestamps
    end
  end

  def self.down
    drop_table :atomic_engine_services
  end
end
