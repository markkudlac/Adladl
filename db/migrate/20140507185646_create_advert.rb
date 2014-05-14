class CreateAdvert < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.integer :group,         :default => 0
      #adtype AD=ad CO=coupon
      t.string :adtype,         :limit => 2, :default => "AD", :null => false
      t.string :urlimg,         :null => false
      t.string :urlhref
      t.string :descript,    :limit => 40
      
      t.timestamps
    end
    add_index :adverts, :group
  end
end
