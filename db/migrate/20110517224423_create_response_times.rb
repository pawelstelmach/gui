class CreateResponseTimes < ActiveRecord::Migration
  def self.up
    create_table :response_times do |t|
      t.float :response_time
      t.integer :mediator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :response_times
  end
end
