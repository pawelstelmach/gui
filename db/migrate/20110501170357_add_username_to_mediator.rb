class AddUsernameToMediator < ActiveRecord::Migration
  def self.up
    add_column :mediators, :username, :string
  end

  def self.down
    remove_column :mediators, :username
  end
end
