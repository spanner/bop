class TreesAndSites < ActiveRecord::Migration
  def change
    create_table :bop_sites do |t|
      t.string :name
      t.string :slug
      t.integer :anchor_id
      t.string :anchor_type
      t.timestamps
    end
    add_index :bop_sites, :anchor_id

    create_table :bop_trees do |t|
      t.integer :site_id
      t.integer :root_page_id
      t.string :name
      t.string :mount_point
      t.timestamps
    end
    add_index :bop_trees, :site_id
    add_index :bop_trees, :root_page_id
    
    add_column :bop_pages, :site_id, :integer
    add_column :bop_pages, :tree_id, :integer
    add_column :bop_stylesheets, :site_id, :integer
    add_column :bop_javascripts, :site_id, :integer
    add_column :bop_templates, :site_id, :integer
    
    remove_column :bop_pages, :anchor_type
    remove_column :bop_pages, :anchor_id
  end
end
