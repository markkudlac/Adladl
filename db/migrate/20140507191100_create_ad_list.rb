class CreateAdList < ActiveRecord::Migration
  def change
    create_table :ad_lists do |t|
      t.integer :device_id,      :null => false
      t.integer :advert_id,      :null => false
      t.integer :action,         :null => false   #0=exclude, 1=save
      
      t.timestamps
    end
    add_index :ad_lists, :device_id
    
    #This key may not be required but ensure uniqu link
    add_index :ad_lists, [:device_id, :advert_id], :unique => true
  end
end
