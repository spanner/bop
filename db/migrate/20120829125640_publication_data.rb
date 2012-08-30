class PublicationData < ActiveRecord::Migration
  def change
    add_column :bop_publications, :title, :string
    add_column :bop_pages, :published_at, :datetime
  end
end
