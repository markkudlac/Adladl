class AddIconToAdverts < ActiveRecord::Migration
  def change
    remove_column :adverts, :urlimg
    add_column :adverts, :icon_id, :integer,      :default => -1
    add_column :adverts, :landing_id, :integer,   :default => -1
    add_column :adverts, :image,    :text
    change_column :adverts, :image,    :text,      :null => false
    add_column :adverts, :filename, :string,      :limit => 40
    add_column :adverts, :filesize, :integer
    add_column :adverts, :client_id, :integer
    change_column :adverts, :client_id, :integer,  :null => false
    
    add_index :adverts, :client_id
  end
 
end
