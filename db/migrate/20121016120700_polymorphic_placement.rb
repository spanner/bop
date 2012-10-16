class PolymorphicPlacement < ActiveRecord::Migration
  def change
    rename_column :bop_placed_blocks, :page_id, :place_id
    add_column :bop_placed_blocks, :place_type
  end
end
