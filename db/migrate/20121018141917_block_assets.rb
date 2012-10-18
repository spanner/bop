class BlockAssets < ActiveRecord::Migration
  def change
    add_column :bop_assets, :original_extension, :string
    add_column :bop_assets, :original_width, :integer
    add_column :bop_assets, :original_height, :integer
    add_column :bop_blocks, :asset_scale_width, :integer
    add_column :bop_blocks, :asset_scale_height, :integer
    add_column :bop_blocks, :asset_offset_left, :integer
    add_column :bop_blocks, :asset_offset_top, :integer
  end
end
