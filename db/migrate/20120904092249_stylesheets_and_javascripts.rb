class StylesheetsAndJavascripts < ActiveRecord::Migration
  def change
    create_table :bop_stylesheets do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
    
    create_table :bop_javascripts do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
