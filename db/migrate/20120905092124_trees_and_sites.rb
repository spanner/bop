class TreesAndSites < ActiveRecord::Migration
  def change
    create_table :bop_sites do |t|
      t.string :name
      t.string :slug
      t.integer :anchor_id
      t.string :anchor_type
      t.timestamps
    end

    create_table :bop_trees do |t|
      t.integer :site_id
      t.integer :root_page_id
      t.string :name
      t.string :mount_point
      t.timestamps
    end
    
    add_column :pages, :site_id, :integer
    add_column :pages, :tree_id, :integer
    add_column :stylesheets, :site_id, :integer
    add_column :javascripts, :site_id, :integer
    add_column :templates, :site_id, :integer
    
    remove_column :pages, :anchor_type
    remove_column :pages, :anchor_id
  end
end
