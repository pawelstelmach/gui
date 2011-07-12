class AddUserIdToSlas < ActiveRecord::Migration
  def self.up
    add_column :slas, :user_id, :integer
  end

  def self.down
    remove_column :slas, :user_id
  end
end
