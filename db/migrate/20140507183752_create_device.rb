class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :tag,     :limit => 30, :null => false
      
      t.timestamps
    end
    add_index :devices, :tag, :unique => true
  end
end
