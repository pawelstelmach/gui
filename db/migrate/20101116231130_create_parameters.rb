class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.integer :settings_id
      t.string :name
      t.string :value
      t.boolean :visible

      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
