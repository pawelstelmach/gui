class CreateMediators < ActiveRecord::Migration
  def self.up
    create_table :mediators do |t|
      t.string :url
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mediators
  end
end
