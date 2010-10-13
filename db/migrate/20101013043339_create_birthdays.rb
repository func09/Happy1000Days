class CreateBirthdays < ActiveRecord::Migration
  def self.up
    create_table :birthdays do |t|
      t.string :uuid, :null => false 
      t.string :nickname
      t.datetime :birthday

      t.timestamps
    end
    add_index :birthdays, [:uuid], :unique => true
  end

  def self.down
    drop_table :birthdays
  end
end
