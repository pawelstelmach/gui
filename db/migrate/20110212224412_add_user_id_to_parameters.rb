class AddUserIdToParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :user_id, :integer
  end

  def self.down
    remove_column :parameters, :user_id
  end
end
