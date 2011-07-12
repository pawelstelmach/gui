class AddEngineToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :engine_name, :string
    add_column :users, :engine_settings, :text
  end

  def self.down
    remove_column :users, :engine_settings
    remove_column :users, :engine_name
  end
end
