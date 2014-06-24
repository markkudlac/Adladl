class AddIconToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :icon, :string
  end
end
