class AddPasswordToMediator < ActiveRecord::Migration
  def self.up
    add_column :mediators, :password, :string
  end

  def self.down
    remove_column :mediators, :password
  end
end
