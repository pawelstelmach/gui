class CreateSmartEngineServices < ActiveRecord::Migration
  def self.up
    create_table :smart_engine_services do |t|
      t.string :name
      t.text :content
      t.integer  :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :smart_engine_services
  end
end
