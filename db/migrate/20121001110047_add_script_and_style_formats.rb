class AddScriptAndStyleFormats < ActiveRecord::Migration
  def change
    add_column :bop_javascripts, :format, :string
    add_column :bop_stylesheets, :format, :string
  end
end
