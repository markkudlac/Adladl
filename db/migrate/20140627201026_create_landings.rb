class CreateLandings < ActiveRecord::Migration
  def change
    create_table :landings do |t|
      t.integer :client_id,   :null => false
      t.text :zipfile,          :null => false
      t.string :zipname,     :limit => 40
      t.integer :filesize
      
      t.timestamps
    end
    
    add_index :landings, :client_id
  end
end
