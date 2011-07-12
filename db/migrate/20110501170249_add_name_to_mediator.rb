class AddNameToMediator < ActiveRecord::Migration
  def self.up
    add_column :mediators, :name, :string
  end

  def self.down
    remove_column :mediators, :name
  end
end
