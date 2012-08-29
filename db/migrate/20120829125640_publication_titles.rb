class PublicationTitles < ActiveRecord::Migration
  def change
    add_column :bop_publications, :title, :string
  end
end
