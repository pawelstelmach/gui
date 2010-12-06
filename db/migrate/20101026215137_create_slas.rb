class CreateSlas < ActiveRecord::Migration
  def self.up
    create_table :slas do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :slas
  end
end
