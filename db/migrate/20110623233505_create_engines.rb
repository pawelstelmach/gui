class CreateEngines < ActiveRecord::Migration
  def self.up
    create_table :engines do |t|
      t.integer :user_id
      t.text :settings

      t.timestamps
    end
  end

  def self.down
    drop_table :engines
  end
end
