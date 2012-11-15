class Deliquidise < ActiveRecord::Migration
  def change
    remove_column :bop_publications, :rendered_head
    rename_column :bop_publications, :rendered_body, :rendered_page
    remove_column :bop_pages, :template_id
    remove_column :bop_blocks, :block_type_name
    remove_column :bop_blocks, :asset_id
    remove_column :bop_blocks, :markup_type
    drop_table :bop_templates
  end
end
