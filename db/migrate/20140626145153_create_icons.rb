class CreateIcons < ActiveRecord::Migration
  def change
    create_table :icons do |t|
      t.integer :client_id,   :null => false
      t.text :image,          :null => false
      t.string :filename,     :limit => 40
      t.integer :filesize
      
      t.timestamps
    end
    
    add_index :icons, :client_id
  end
end
