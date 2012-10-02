class StylesheetsAndJavascripts < ActiveRecord::Migration
  def change
    create_table :bop_stylesheets do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.integer :user_id
      t.timestamps
    end
    add_index :bop_stylesheets, :slug
    add_index :bop_stylesheets, :user_id
    
    create_table :bop_javascripts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.integer :user_id
      t.timestamps
    end
    add_index :bop_javascripts, :slug
    add_index :bop_javascripts, :user_id
  end
end
