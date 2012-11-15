class PolymorphicPlacement < ActiveRecord::Migration
  def change
    rename_column :bop_placed_blocks, :page_id, :place_id
    add_column :bop_placed_blocks, :place_type, :string
    rename_column :bop_placed_blocks, :block_id, :item_id
    add_column :bop_placed_blocks, :item_type, :string
    rename_table :bop_placed_blocks, :bop_placements

    add_column :bop_blocks, :name, :string
    
    add_column :bop_assets, :original_extension, :string
    add_column :bop_assets, :original_width, :integer
    add_column :bop_assets, :original_height, :integer
    
    add_column :bop_placements, :asset_scale_width, :integer
    add_column :bop_placements, :asset_scale_height, :integer
    add_column :bop_placements, :asset_offset_left, :integer
    add_column :bop_placements, :asset_offset_top, :integer
  end
end
