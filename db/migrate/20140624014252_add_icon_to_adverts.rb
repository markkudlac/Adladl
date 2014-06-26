class AddIconToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :icon, :string
    add_column :adverts, :icon_image, :string
    add_column :adverts, :icon_filename, :string,    :limit => 40
    add_column :adverts, :ad_image, :string
    add_column :adverts, :ad_filename, :string,    :limit => 40
    add_column :adverts, :client_id, :integer  #Should set rebuild , :null => false
    
    add_index :adverts, :client_id
  end
 
end
