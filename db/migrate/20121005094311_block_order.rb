class BlockOrder < ActiveRecord::Migration
  def change
    add_column :bop_placed_blocks, :position, :integer
  end
end
