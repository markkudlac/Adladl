class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :admin_id,    :null => false
      t.string :apikey,       :null => false, :limit => 10
      t.string :company,      :limit => 70
      t.string :firstname,    :limit => 40
      t.string :surname,      :limit => 40
      
      t.timestamps
    end
    
    add_index :clients, :admin_id, :unique => true
    add_index :clients, :apikey, :unique => true
  end
end
