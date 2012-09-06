class AssetSlugs < ActiveRecord::Migration
  def change
    add_column :bop_javascripts, :slug, :string
    add_index :bop_javascripts, :slug
    add_column :bop_stylesheets, :slug, :string
    add_index :bop_stylesheets, :slug
  end
end
