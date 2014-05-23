class AddInstructCntToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :instruct_cnt, :integer, :default => 0
  end
end
